import 'dart:math';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'namespace.dart';
import 'result.dart';
import 'stack.dart';
import 'try_frame.dart';
import 'vm.dart';

enum BeizeInterpreterState {
  ready,
  running,
  finished,
}

class BeizeInterpreter {
  BeizeInterpreter(this.frame)
      : chunk = frame.function.chunk,
        namespace = frame.namespace;

  final BeizeCallFrame frame;
  final BeizeChunk chunk;
  BeizeNamespace namespace;

  BeizeInterpreterState state = BeizeInterpreterState.ready;
  final BeizeStack stack = BeizeStack();

  BeizeInterpreterResult run() {
    state = BeizeInterpreterState.running;
    try {
      final BeizeInterpreterResult result = interpret();
      state = BeizeInterpreterState.finished;
      return result;
    } catch (err, stackTrace) {
      state = BeizeInterpreterState.finished;
      return BeizeInterpreterResult.fail(
        BeizeExceptionValue(
          'BeizeRuntimeException: $err',
          frame.getStackTrace(),
          stackTrace,
        ),
      );
    }
  }

  Future<BeizeInterpreterResult> runAsync() async {
    state = BeizeInterpreterState.running;
    try {
      final BeizeInterpreterResult result = await interpretAsync();
      state = BeizeInterpreterState.finished;
      return result;
    } catch (err, stackTrace) {
      state = BeizeInterpreterState.finished;
      return BeizeInterpreterResult.fail(
        BeizeExceptionValue(
          'BeizeRuntimeException: $err',
          frame.getStackTrace(),
          stackTrace,
        ),
      );
    }
  }

  Future<BeizeInterpreterResult> interpretAsync() async {
    BeizeInterpreterResult? result;
    while (frame.ip < chunk.length) {
      final BeizeOpCodes opCode = chunk.opCodeAt(frame.ip);
      frame.sip = frame.ip;
      frame.ip++;
      switch (opCode) {
        case BeizeOpCodes.opAwait:
          BeizeValue value = stack.pop();
          while (value is BeizeUnawaitedValue) {
            final BeizeInterpreterResult result = await value.execute(frame);
            if (result.isFailure) {
              return handleExceptionAsync(result.error);
            }
            value = result.value;
          }
          stack.push(value);

        default:
          result = interpretCurrent();
      }
      if (result != null) break;
    }
    return result ?? BeizeInterpreterResult.success(BeizeNullValue.value);
  }

  BeizeInterpreterResult interpret() {
    BeizeInterpreterResult? result;
    while (frame.ip < chunk.length) {
      frame.sip = frame.ip;
      frame.ip++;
      result = interpretCurrent();
      if (result != null) break;
    }
    return result ?? BeizeInterpreterResult.success(BeizeNullValue.value);
  }

  BeizeInterpreterResult? interpretCurrent() {
    final BeizeOpCodes opCode = chunk.opCodeAt(frame.ip - 1);
    switch (opCode) {
      case BeizeOpCodes.opBeginScope:
        frame.scopeDepth++;
        namespace = namespace.enclosed;

      case BeizeOpCodes.opEndScope:
        frame.scopeDepth--;
        namespace = namespace.parent!;

      case BeizeOpCodes.opConstant:
        final BeizeConstant constant = frame.readConstantAt(frame.ip);
        final BeizeValue value;
        if (constant is BeizeFunctionConstant) {
          final BeizeNamespace functionNamespace = namespace.enclosed;
          functionNamespace.declare('this', BeizeNullValue.value);
          functionNamespace.declare('super', BeizeNullValue.value);
          value = BeizeFunctionValue(
            constant: constant,
            namespace: functionNamespace,
          );
        } else if (constant is double) {
          value = BeizeNumberValue(constant);
        } else if (constant is String) {
          value = BeizeStringValue(constant);
        } else {
          throw BeizeRuntimeException.unknownConstant(constant);
        }
        stack.push(value);
        frame.ip++;

      case BeizeOpCodes.opTrue:
        stack.push(frame.vm.globals.trueValue);

      case BeizeOpCodes.opFalse:
        stack.push(frame.vm.globals.falseValue);

      case BeizeOpCodes.opNull:
        stack.push(BeizeNullValue.value);

      case BeizeOpCodes.opPop:
        stack.pop();

      case BeizeOpCodes.opTop:
        stack.push(stack.top());

      case BeizeOpCodes.opJumpIfNull:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        if (stack.top() is BeizeNullValue) {
          frame.ip += offset;
        }

      case BeizeOpCodes.opJumpIfFalse:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        if (stack.top().isFalsey) {
          frame.ip += offset;
        }

      case BeizeOpCodes.opJump:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip += offset + 1;

      case BeizeOpCodes.opAbsoluteJump:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip = offset;

      case BeizeOpCodes.opCall:
        final int count = chunk.codeAt(frame.ip);
        frame.ip++;
        final List<BeizeValue> arguments =
            List<BeizeValue>.filled(count, BeizeNullValue.value);
        for (int i = count - 1; i >= 0; i--) {
          arguments[i] = stack.pop();
        }
        final BeizeValue value = stack.pop();
        final BeizeInterpreterResult result = frame.callValue(value, arguments);
        if (result.isFailure) {
          return handleException(result.error);
        }
        stack.push(result.value);

      case BeizeOpCodes.opReturn:
        frame.ip = chunk.length;
        final BeizeValue value = stack.pop();
        return BeizeInterpreterResult.success(value);

      case BeizeOpCodes.opPrint:
        if (!frame.vm.options.disablePrint) {
          final String text =
              frame.vm.options.printPrefix + stack.pop().kToString();
          if (frame.vm.options.onPrint != null) {
            frame.vm.options.onPrint?.call(text);
          } else {
            // ignore: avoid_print
            print(text);
          }
        }

      case BeizeOpCodes.opNegate:
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue) {
          return handleInvalidUnary(
            'Cannot perform negate on "${a.kName}"',
          );
        }
        stack.push(a.negate);

      case BeizeOpCodes.opBitwiseNot:
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue) {
          return handleInvalidUnary(
            'Cannot perform bitwise not on "${a.kName}"',
          );
        }
        stack.push(BeizeNumberValue((~a.unsafeIntValue).toDouble()));

      case BeizeOpCodes.opEqual:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        stack.push(
          BeizeBooleanValue(
            frame.vm.globals,
            a.kHashCode == b.kHashCode && a.kEquals(b),
          ),
        );

      case BeizeOpCodes.opNot:
        stack.push(BeizeBooleanValue(frame.vm.globals, !stack.pop().isTruthy));

      case BeizeOpCodes.opAdd:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeStringValue || b is BeizeStringValue) {
          stack.push(BeizeStringValue(a.kToString() + b.kToString()));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(BeizeNumberValue(a.value + b.value));
        } else {
          return handleInvalidBinary(
            'Cannot perform addition between "${a.kName}" and "${b.kName}"',
          );
        }

      case BeizeOpCodes.opSubtract:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform subtraction between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeNumberValue(a.value - b.value));

      case BeizeOpCodes.opMultiply:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform multiplication between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeNumberValue(a.value * b.value));

      case BeizeOpCodes.opDivide:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform division between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeNumberValue(a.value / b.value));

      case BeizeOpCodes.opFloor:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform floor division between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeNumberValue((a.value ~/ b.value).toDouble()));

      case BeizeOpCodes.opModulo:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform remainder between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeNumberValue(a.value % b.value));

      case BeizeOpCodes.opExponent:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform exponentiation between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeNumberValue(pow(a.value, b.value).toDouble()));

      case BeizeOpCodes.opLess:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform comparison between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeBooleanValue(frame.vm.globals, a.value < b.value));

      case BeizeOpCodes.opGreater:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform comparison between "${a.kName}" and "${b.kName}"',
          );
        }
        stack.push(BeizeBooleanValue(frame.vm.globals, a.value > b.value));

      case BeizeOpCodes.opBitwiseAnd:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeBooleanValue && b is BeizeBooleanValue) {
          stack.push(BeizeBooleanValue(frame.vm.globals, a.value & b.value));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(
            BeizeNumberValue(
              (a.unsafeIntValue & b.unsafeIntValue).toDouble(),
            ),
          );
        } else {
          return handleInvalidBinary(
            'Cannot perform bitwise AND between "${a.kName}" and "${b.kName}"',
          );
        }

      case BeizeOpCodes.opBitwiseOr:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeBooleanValue && b is BeizeBooleanValue) {
          stack.push(BeizeBooleanValue(frame.vm.globals, a.value | b.value));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(
            BeizeNumberValue((a.intValue | b.intValue).toDouble()),
          );
        } else {
          return handleInvalidBinary(
            'Cannot perform bitwise OR between "${a.kName}" and "${b.kName}"',
          );
        }

      case BeizeOpCodes.opBitwiseXor:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeBooleanValue && b is BeizeBooleanValue) {
          stack.push(BeizeBooleanValue(frame.vm.globals, a.value ^ b.value));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(
            BeizeNumberValue((a.intValue ^ b.intValue).toDouble()),
          );
        } else {
          return handleInvalidBinary(
            'Cannot perform bitwise XOR between "${a.kName}" and "${b.kName}"',
          );
        }

      case BeizeOpCodes.opDeclare:
        final BeizeValue value = stack.top();
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        namespace.declare(name, value);

      case BeizeOpCodes.opAssign:
        final BeizeValue value = stack.top();
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        namespace.assign(name, value);

      case BeizeOpCodes.opLookup:
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        stack.push(namespace.lookup(name));

      case BeizeOpCodes.opList:
        final int count = chunk.codeAt(frame.ip);
        frame.ip++;
        final List<BeizeValue> values = List<BeizeValue>.filled(
          count,
          BeizeNullValue.value,
          growable: true,
        );
        for (int i = count - 1; i >= 0; i--) {
          values[i] = stack.pop();
        }
        stack.push(BeizeListValue(values));

      case BeizeOpCodes.opObject:
        final int count = chunk.codeAt(frame.ip);
        frame.ip++;
        final BeizeObjectValue obj = BeizeObjectValue();
        for (int i = 0; i < count; i++) {
          final BeizeValue value = stack.pop();
          final BeizeValue key = stack.pop();
          if (value is BeizeFunctionValue) {
            value.namespace.assign('this', obj);
            value.namespace.assign('super', BeizeNullValue.value);
          }
          obj.set(key, value);
        }
        stack.push(obj);

      case BeizeOpCodes.opGetProperty:
        final BeizeValue name = stack.pop();
        final BeizeValue obj = stack.pop();
        if (obj is! BeizePrimitiveObjectValue) {
          return handleInvalidMemberAccess(
            'Cannot use member accessor on "${obj.kName}"',
          );
        }
        final BeizeValue value = obj.getAlongFrame(frame, name);
        stack.push(value);

      case BeizeOpCodes.opSetProperty:
        final BeizeValue value = stack.pop();
        final BeizeValue name = stack.pop();
        final BeizeValue obj = stack.pop();
        if (obj is! BeizePrimitiveObjectValue) {
          return handleInvalidMemberAccess(
            'Cannot do member assign on "${obj.kName}"',
          );
        }
        obj.set(name, value);
        stack.push(value);

      case BeizeOpCodes.opBeginTry:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        frame.tryFrames.add(
          BeizeTryFrame(offset: offset, scopeDepth: frame.scopeDepth),
        );

      case BeizeOpCodes.opEndTry:
        frame.tryFrames.removeLast();

      case BeizeOpCodes.opThrow:
        final BeizeValue err = stack.pop();
        if (err is BeizeExceptionValue) {
          return handleException(err);
        }
        return handleCustomException(
          'InvalidThrow',
          'Cannot throw value of "${err.kName}"',
        );

      case BeizeOpCodes.opImport:
        final int moduleIndex = chunk.codeAt(frame.ip);
        frame.ip++;
        final BeizeModuleValue? pValue = frame.vm.lookupModule(moduleIndex);
        if (pValue != null) {
          stack.push(pValue);
        } else {
          final BeizePreparedModule module = frame.vm.prepareModule(
            moduleIndex,
            isEntrypoint: false,
          );
          final BeizeInterpreterResult result = frame.vm.loadModule(module);
          if (result.isFailure) {
            return handleException(result.error);
          }
          stack.push(module.value);
        }

      case BeizeOpCodes.opIs:
        final BeizeValue clazz = stack.pop();
        final BeizeValue obj = stack.pop();
        if (clazz is! BeizePrimitiveClassValue) {
          return handleInvalidBinary(
            'Cannot perform instance check with "${clazz.kName}"',
          );
        }
        stack.push(
          BeizeBooleanValue(
            frame.vm.globals,
            obj is BeizePrimitiveObjectValue && clazz.kIsInstance(obj),
          ),
        );

      case BeizeOpCodes.opClass:
        final bool hasParent = chunk.codeAt(frame.ip) == 1;
        final int count = chunk.codeAt(frame.ip + 1);
        frame.ip += 2 + count;
        final BeizeVMClassValue? parentClass =
            hasParent ? stack.peek(count * 2) : null;
        final BeizeVMClassValue clazz =
            BeizeVMClassValue(vm: frame.vm, parentVMClass: parentClass);
        final BeizeValue parentClassValue = parentClass ?? BeizeNullValue.value;
        for (int i = 0; i < count; i++) {
          final bool isStatic = chunk.codeAt(frame.ip - i - 1) == 0;
          if (isStatic) {
            final BeizeValue value = stack.pop();
            final BeizeValue key = stack.pop();
            if (value is BeizeFunctionValue) {
              value.namespace.assign('this', clazz);
              value.namespace.assign('super', parentClassValue);
            }
            clazz.set(key, value);
            continue;
          }
          final BeizeValue value = stack.pop();
          final BeizeValue key = stack.pop();
          clazz.instanceFields.set(key, value);
        }
        if (hasParent) {
          stack.pop();
        }
        stack.push(clazz);

      default:
        throw BeizeRuntimeException.unknownOpCode(opCode);
    }
    return null;
  }

  BeizeInterpreterResult handleCustomException(
    final String prefix,
    final String message,
  ) {
    final BeizeExceptionValue err = BeizeExceptionValue(
      '$prefix: $message',
      frame.getStackTrace(),
    );
    return handleException(err);
  }

  BeizeInterpreterResult handleInvalidMemberAccess(final String message) =>
      handleCustomException('InvalidMemberAccess', message);

  BeizeInterpreterResult handleInvalidUnary(final String message) =>
      handleCustomException('InvalidUnaryOperation', message);

  BeizeInterpreterResult handleInvalidBinary(final String message) =>
      handleCustomException('InvalidBinaryOperation', message);

  BeizeInterpreterResult? handleExceptionSynchronization(
    final BeizeExceptionValue err,
  ) {
    if (frame.tryFrames.isEmpty) {
      return BeizeInterpreterResult.fail(err);
    }
    final BeizeTryFrame tryFrame = frame.tryFrames.removeLast();
    final int scopeDiff = frame.scopeDepth - tryFrame.scopeDepth - 1;
    if (scopeDiff > 0) {
      for (int i = 0; i < scopeDiff; i++) {
        namespace = namespace.parent!;
      }
    }
    frame.ip = tryFrame.offset;
    stack.push(err);
    return null;
  }

  BeizeInterpreterResult handleException(final BeizeExceptionValue err) {
    final BeizeInterpreterResult? synchronized =
        handleExceptionSynchronization(err);
    return synchronized ?? interpret();
  }

  Future<BeizeInterpreterResult> handleExceptionAsync(
    final BeizeExceptionValue err,
  ) {
    final BeizeInterpreterResult? synchronized =
        handleExceptionSynchronization(err);
    if (synchronized != null) {
      return Future<BeizeInterpreterResult>.value(synchronized);
    }
    return interpretAsync();
  }
}
