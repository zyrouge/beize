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
          'RuntimeException: $err',
          frame.getStackTrace(),
          stackTrace.toString(),
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
          'RuntimeException: $err',
          frame.getStackTrace(),
          stackTrace.toString(),
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
          final BeizeValue value = stack.pop();
          if (value is BeizeUnawaitedValue) {
            final BeizeInterpreterResult result = await value.execute(frame);
            if (result.isFailure) {
              return handleExceptionAsync(result.error);
            }
            stack.push(result.value);
          } else {
            stack.push(value);
          }
          break;

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
        break;

      case BeizeOpCodes.opEndScope:
        frame.scopeDepth--;
        namespace = namespace.parent!;
        break;

      case BeizeOpCodes.opConstant:
        final BeizeConstant constant = frame.readConstantAt(frame.ip);
        final BeizeValue value;
        if (constant is BeizeFunctionConstant) {
          final BeizeNamespace functionNamespace = namespace.enclosed;
          functionNamespace.declare('this', BeizeNullValue.value);
          value = BeizeFunctionValue(
            constant: constant,
            namespace: functionNamespace,
          );
        } else if (constant is double) {
          value = BeizeNumberValue(constant);
        } else if (constant is String) {
          value = BeizeStringValue(constant);
        } else {
          throw BeizeRuntimeExpection.unknownConstant(constant);
        }
        stack.push(value);
        frame.ip++;
        break;

      case BeizeOpCodes.opTrue:
        stack.push(BeizeBooleanValue.trueValue);
        break;

      case BeizeOpCodes.opFalse:
        stack.push(BeizeBooleanValue.falseValue);
        break;

      case BeizeOpCodes.opNull:
        stack.push(BeizeNullValue.value);
        break;

      case BeizeOpCodes.opPop:
        stack.pop();
        break;

      case BeizeOpCodes.opTop:
        stack.push(stack.top());
        break;

      case BeizeOpCodes.opJumpIfNull:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        if (stack.top() is BeizeNullValue) {
          frame.ip += offset;
        }
        break;

      case BeizeOpCodes.opJumpIfFalse:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        if (stack.top().isFalsey) {
          frame.ip += offset;
        }
        break;

      case BeizeOpCodes.opJump:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip += offset + 1;
        break;

      case BeizeOpCodes.opAbsoluteJump:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip = offset;
        break;

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
        break;

      case BeizeOpCodes.opReturn:
        frame.ip = chunk.length;
        final BeizeValue value = stack.pop();
        return BeizeInterpreterResult.success(value);

      case BeizeOpCodes.opPrint:
        if (!frame.vm.options.disablePrint) {
          // ignore: avoid_print
          print(frame.vm.options.printPrefix + stack.pop().kToString());
        }
        break;

      case BeizeOpCodes.opNegate:
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue) {
          return handleInvalidUnary(
            'Cannot perform negate on "${a.kind.code}"',
          );
        }
        stack.push(a.negate);
        break;

      case BeizeOpCodes.opBitwiseNot:
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue) {
          return handleInvalidUnary(
            'Cannot perform bitwise not on "${a.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue((~a.unsafeIntValue).toDouble()));
        break;

      case BeizeOpCodes.opEqual:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        stack.push(BeizeBooleanValue(a.kHashCode == b.kHashCode));
        break;

      case BeizeOpCodes.opNot:
        stack.push(BeizeBooleanValue(!stack.pop().isTruthy));
        break;

      case BeizeOpCodes.opAdd:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeStringValue || b is BeizeStringValue) {
          stack.push(BeizeStringValue(a.kToString() + b.kToString()));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(BeizeNumberValue(a.value + b.value));
        } else {
          return handleInvalidBinary(
            'Cannot perform addition between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        break;

      case BeizeOpCodes.opSubtract:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform subtraction between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue(a.value - b.value));
        break;

      case BeizeOpCodes.opMultiply:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform multiplication between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue(a.value * b.value));
        break;

      case BeizeOpCodes.opDivide:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform division between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue(a.value / b.value));
        break;

      case BeizeOpCodes.opFloor:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform floor division between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue((a.value ~/ b.value).toDouble()));
        break;

      case BeizeOpCodes.opModulo:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform remainder between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue(a.value % b.value));
        break;

      case BeizeOpCodes.opExponent:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform exponentiation between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeNumberValue(pow(a.value, b.value).toDouble()));
        break;

      case BeizeOpCodes.opLess:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform comparison between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeBooleanValue(a.value < b.value));
        break;

      case BeizeOpCodes.opGreater:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is! BeizeNumberValue || b is! BeizeNumberValue) {
          return handleInvalidBinary(
            'Cannot perform comparison between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        stack.push(BeizeBooleanValue(a.value > b.value));
        break;

      case BeizeOpCodes.opBitwiseAnd:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeBooleanValue && b is BeizeBooleanValue) {
          stack.push(BeizeBooleanValue(a.value & b.value));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(
            BeizeNumberValue(
              (a.unsafeIntValue & b.unsafeIntValue).toDouble(),
            ),
          );
        } else {
          return handleInvalidBinary(
            'Cannot perform bitwise AND between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        break;

      case BeizeOpCodes.opBitwiseOr:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeBooleanValue && b is BeizeBooleanValue) {
          stack.push(BeizeBooleanValue(a.value | b.value));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(
            BeizeNumberValue((a.intValue | b.intValue).toDouble()),
          );
        } else {
          return handleInvalidBinary(
            'Cannot perform bitwise OR between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        break;

      case BeizeOpCodes.opBitwiseXor:
        final BeizeValue b = stack.pop();
        final BeizeValue a = stack.pop();
        if (a is BeizeBooleanValue && b is BeizeBooleanValue) {
          stack.push(BeizeBooleanValue(a.value ^ b.value));
        } else if (a is BeizeNumberValue && b is BeizeNumberValue) {
          stack.push(
            BeizeNumberValue((a.intValue ^ b.intValue).toDouble()),
          );
        } else {
          return handleInvalidBinary(
            'Cannot perform bitwise XOR between "${a.kind.code}" and "${b.kind.code}"',
          );
        }
        break;

      case BeizeOpCodes.opDeclare:
        final BeizeValue value = stack.top();
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        namespace.declare(name, value);
        break;

      case BeizeOpCodes.opAssign:
        final BeizeValue value = stack.top();
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        namespace.assign(name, value);
        break;

      case BeizeOpCodes.opLookup:
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        stack.push(namespace.lookup(name));
        break;

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
        break;

      case BeizeOpCodes.opObject:
        final int count = chunk.codeAt(frame.ip);
        frame.ip++;
        final BeizeObjectValue obj = BeizeObjectValue();
        for (int i = 0; i < count; i++) {
          final BeizeValue value = stack.pop();
          final BeizeValue key = stack.pop();
          if (value is BeizeFunctionValue) {
            value.namespace.assign('this', obj);
          }
          obj.set(key, value);
        }
        stack.push(obj);
        break;

      case BeizeOpCodes.opGetProperty:
        final BeizeValue name = stack.pop();
        final BeizePrimitiveObjectValue obj = stack.pop();
        final BeizeValue value = obj.get(name);
        stack.push(value);
        break;

      case BeizeOpCodes.opSetProperty:
        final BeizeValue value = stack.pop();
        final BeizeValue name = stack.pop();
        final BeizePrimitiveObjectValue obj = stack.pop();
        obj.set(name, value);
        stack.push(value);
        break;

      case BeizeOpCodes.opBeginTry:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        frame.tryFrames.add(
          BeizeTryFrame(offset: offset, scopeDepth: frame.scopeDepth),
        );
        break;

      case BeizeOpCodes.opEndTry:
        frame.tryFrames.removeLast();
        break;

      case BeizeOpCodes.opThrow:
        final BeizeValue err = stack.pop();
        if (err is BeizeExceptionValue) {
          return handleException(err);
        }
        return handleCustomException(
          'InvalidThrow',
          'Cannot throw value of "${err.kind.code}"',
        );

      case BeizeOpCodes.opModule:
        final int moduleId = chunk.codeAt(frame.ip);
        final String name = frame.readConstantAt(frame.ip + 1) as String;
        frame.ip += 2;
        namespace.declare(name, BeizeObjectValue());
        final BeizeInterpreterResult result = frame.vm.loadModule(moduleId);
        if (result.isFailure) {
          return handleException(result.error);
        }
        namespace.assign(name, result.value);
        break;

      default:
        throw BeizeRuntimeExpection.unknownOpCode(opCode);
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

  BeizeInterpreterResult handleInvalidUnary(final String message) =>
      handleCustomException('InvalidUnaryOperation', message);

  BeizeInterpreterResult handleInvalidBinary(final String message) =>
      handleCustomException('InvalidBinaryOperation', message);

  BeizeInterpreterResult handleExceptionSynchronization(
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
    return interpret();
  }

  BeizeInterpreterResult handleException(final BeizeExceptionValue err) {
    handleExceptionSynchronization(err);
    return interpret();
  }

  Future<BeizeInterpreterResult> handleExceptionAsync(
    final BeizeExceptionValue err,
  ) {
    handleExceptionSynchronization(err);
    return interpretAsync();
  }
}