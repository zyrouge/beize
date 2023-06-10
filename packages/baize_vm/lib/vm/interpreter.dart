import 'dart:math';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'result.dart';
import 'stack.dart';
import 'try_frame.dart';

enum BaizeInterpreterState {
  ready,
  running,
  finished,
}

class BaizeInterpreter {
  BaizeInterpreter(this.frame)
      : chunk = frame.function.chunk,
        namespace = frame.namespace;

  final BaizeCallFrame frame;
  final BaizeChunk chunk;
  BaizeNamespace namespace;

  BaizeInterpreterState state = BaizeInterpreterState.ready;
  final BaizeStack stack = BaizeStack();
  BaizeValue resultValue = BaizeNullValue.value;

  Future<BaizeInterpreterResult> run() async {
    state = BaizeInterpreterState.running;
    try {
      final BaizeInterpreterResult result = await interpret();
      return result;
    } catch (err, stackTrace) {
      return BaizeInterpreterResult.fail(
        BaizeExceptionNatives.newExceptionNative(
          'BaizeRuntimeException: $err',
          '${frame.getStackTrace()}\nDart Stack Trace:\n$stackTrace',
        ),
      );
    }
  }

  Future<BaizeInterpreterResult> interpret() async {
    while (frame.ip < chunk.length) {
      final BaizeOpCodes opCode = chunk.opCodeAt(frame.ip);
      frame.sip = frame.ip;
      frame.ip++;
      switch (opCode) {
        case BaizeOpCodes.opBeginScope:
          frame.scopeDepth++;
          namespace = namespace.enclosed;
          break;

        case BaizeOpCodes.opEndScope:
          frame.scopeDepth--;
          namespace = namespace.parent!;
          break;

        case BaizeOpCodes.opConstant:
          final BaizeConstant constant = frame.readConstantAt(frame.ip);
          final BaizeValue value;
          if (constant is BaizeFunctionConstant) {
            final BaizeNamespace functionNamespace = namespace.enclosed;
            functionNamespace.declare('this', BaizeNullValue.value);
            value = BaizeFunctionValue(
              constant: constant,
              namespace: functionNamespace,
            );
          } else if (constant is double) {
            value = BaizeNumberValue(constant);
          } else if (constant is String) {
            value = BaizeStringValue(constant);
          } else {
            throw BaizeRuntimeExpection.unknownConstant(constant);
          }
          stack.push(value);
          frame.ip++;
          break;

        case BaizeOpCodes.opTrue:
          stack.push(BaizeBooleanValue.trueValue);
          break;

        case BaizeOpCodes.opFalse:
          stack.push(BaizeBooleanValue.falseValue);
          break;

        case BaizeOpCodes.opNull:
          stack.push(BaizeNullValue.value);
          break;

        case BaizeOpCodes.opPop:
          stack.pop();
          break;

        case BaizeOpCodes.opTop:
          stack.push(stack.top());
          break;

        case BaizeOpCodes.opJumpIfNull:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip++;
          if (stack.top() is BaizeNullValue) {
            frame.ip += offset;
          }
          break;

        case BaizeOpCodes.opJumpIfFalse:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip++;
          if (stack.top().isFalsey) {
            frame.ip += offset;
          }
          break;

        case BaizeOpCodes.opJump:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip += offset + 1;
          break;

        case BaizeOpCodes.opAbsoluteJump:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip = offset;
          break;

        case BaizeOpCodes.opCall:
          final int count = chunk.codeAt(frame.ip);
          frame.ip++;
          final List<BaizeValue> arguments =
              List<BaizeValue>.filled(count, BaizeNullValue.value);
          for (int i = count - 1; i >= 0; i--) {
            arguments[i] = stack.pop();
          }
          final BaizeValue value = stack.pop();
          final BaizeInterpreterResult result =
              await frame.callValue(value, arguments);
          if (result.isFailure) {
            return handleError(result.value);
          }
          stack.push(result.value);
          break;

        case BaizeOpCodes.opReturn:
          frame.ip = chunk.length;
          resultValue = stack.pop();
          break;

        case BaizeOpCodes.opPrint:
          if (!frame.vm.options.disablePrint) {
            // ignore: avoid_print
            print('print: ${stack.pop().kToString()}');
          }
          break;

        case BaizeOpCodes.opNegate:
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue) {
            return handleInvalidUnary(
              'Cannot perform negate on "${a.kind.code}"',
            );
          }
          stack.push(a.negate);
          break;

        case BaizeOpCodes.opBitwiseNot:
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue) {
            return handleInvalidUnary(
              'Cannot perform bitwise not on "${a.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue((~a.unsafeIntValue).toDouble()));
          break;

        case BaizeOpCodes.opEqual:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          stack.push(BaizeBooleanValue(a.kHashCode == b.kHashCode));
          break;

        case BaizeOpCodes.opNot:
          stack.push(BaizeBooleanValue(!stack.pop().isTruthy));
          break;

        case BaizeOpCodes.opAdd:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is BaizeStringValue || b is BaizeStringValue) {
            stack.push(BaizeStringValue(a.kToString() + b.kToString()));
          } else if (a is BaizeNumberValue && b is BaizeNumberValue) {
            stack.push(BaizeNumberValue(a.value + b.value));
          } else {
            return handleInvalidBinary(
              'Cannot perform addition between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case BaizeOpCodes.opSubtract:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform subtraction between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue(a.value - b.value));
          break;

        case BaizeOpCodes.opMultiply:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform multiplication between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue(a.value * b.value));
          break;

        case BaizeOpCodes.opDivide:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform division between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue(a.value / b.value));
          break;

        case BaizeOpCodes.opFloor:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform floor division between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue((a.value ~/ b.value).toDouble()));
          break;

        case BaizeOpCodes.opModulo:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform remainder between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue(a.value % b.value));
          break;

        case BaizeOpCodes.opExponent:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform exponentiation between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeNumberValue(pow(a.value, b.value).toDouble()));
          break;

        case BaizeOpCodes.opLess:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform comparison between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeBooleanValue(a.value < b.value));
          break;

        case BaizeOpCodes.opGreater:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is! BaizeNumberValue || b is! BaizeNumberValue) {
            return handleInvalidBinary(
              'Cannot perform comparison between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          stack.push(BaizeBooleanValue(a.value > b.value));
          break;

        case BaizeOpCodes.opBitwiseAnd:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is BaizeBooleanValue && b is BaizeBooleanValue) {
            stack.push(BaizeBooleanValue(a.value & b.value));
          } else if (a is BaizeNumberValue && b is BaizeNumberValue) {
            stack.push(
              BaizeNumberValue(
                (a.unsafeIntValue & b.unsafeIntValue).toDouble(),
              ),
            );
          } else {
            return handleInvalidBinary(
              'Cannot perform bitwise AND between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case BaizeOpCodes.opBitwiseOr:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is BaizeBooleanValue && b is BaizeBooleanValue) {
            stack.push(BaizeBooleanValue(a.value | b.value));
          } else if (a is BaizeNumberValue && b is BaizeNumberValue) {
            stack.push(
              BaizeNumberValue((a.intValue | b.intValue).toDouble()),
            );
          } else {
            return handleInvalidBinary(
              'Cannot perform bitwise OR between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case BaizeOpCodes.opBitwiseXor:
          final BaizeValue b = stack.pop();
          final BaizeValue a = stack.pop();
          if (a is BaizeBooleanValue && b is BaizeBooleanValue) {
            stack.push(BaizeBooleanValue(a.value ^ b.value));
          } else if (a is BaizeNumberValue && b is BaizeNumberValue) {
            stack.push(
              BaizeNumberValue((a.intValue ^ b.intValue).toDouble()),
            );
          } else {
            return handleInvalidBinary(
              'Cannot perform bitwise XOR between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case BaizeOpCodes.opDeclare:
          final BaizeValue value = stack.top();
          final String name = frame.readConstantAt(frame.ip) as String;
          frame.ip++;
          namespace.declare(name, value);
          break;

        case BaizeOpCodes.opAssign:
          final BaizeValue value = stack.top();
          final String name = frame.readConstantAt(frame.ip) as String;
          frame.ip++;
          namespace.assign(name, value);
          break;

        case BaizeOpCodes.opLookup:
          final String name = frame.readConstantAt(frame.ip) as String;
          frame.ip++;
          stack.push(namespace.lookup(name));
          break;

        case BaizeOpCodes.opList:
          final int count = chunk.codeAt(frame.ip);
          frame.ip++;
          final List<BaizeValue> values = List<BaizeValue>.filled(
            count,
            BaizeNullValue.value,
            growable: true,
          );
          for (int i = count - 1; i >= 0; i--) {
            values[i] = stack.pop();
          }
          stack.push(BaizeListValue(values));
          break;

        case BaizeOpCodes.opObject:
          final int count = chunk.codeAt(frame.ip);
          frame.ip++;
          final BaizeObjectValue obj = BaizeObjectValue();
          for (int i = 0; i < count; i++) {
            final BaizeValue value = stack.pop();
            final BaizeValue key = stack.pop();
            if (value is BaizeFunctionValue) {
              value.namespace.assign('this', obj);
            }
            obj.set(key, value);
          }
          stack.push(obj);
          break;

        case BaizeOpCodes.opGetProperty:
          final BaizeValue name = stack.pop();
          final BaizePrimitiveObjectValue obj = stack.pop();
          final BaizeValue value = obj.get(name);
          stack.push(value);
          break;

        case BaizeOpCodes.opSetProperty:
          final BaizeValue value = stack.pop();
          final BaizeValue name = stack.pop();
          final BaizePrimitiveObjectValue obj = stack.pop();
          obj.set(name, value);
          stack.push(value);
          break;

        case BaizeOpCodes.opBeginTry:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip++;
          frame.tryFrames.add(
            BaizeTryFrame(offset: offset, scopeDepth: frame.scopeDepth),
          );
          break;

        case BaizeOpCodes.opEndTry:
          frame.tryFrames.removeLast();
          break;

        case BaizeOpCodes.opThrow:
          return handleError(stack.pop());

        case BaizeOpCodes.opModule:
          final String module = frame.readConstantAt(frame.ip) as String;
          final String name = frame.readConstantAt(frame.ip + 1) as String;
          frame.ip += 2;
          final BaizeInterpreterResult result =
              await frame.vm.loadModule(module);
          if (result.isFailure) {
            return handleError(result.value);
          }
          namespace.declare(name, result.value);
          break;

        default:
          throw BaizeRuntimeExpection.unknownOpCode(opCode);
      }
    }

    state = BaizeInterpreterState.finished;
    return BaizeInterpreterResult.success(resultValue);
  }

  Future<BaizeInterpreterResult> handleInvalidUnary(final String message) {
    final BaizeValue error = BaizeExceptionNatives.newExceptionNative(
      'BaizeInvalidUnaryOperation: $message',
      frame.getStackTrace(),
    );
    return handleError(error);
  }

  Future<BaizeInterpreterResult> handleInvalidBinary(final String message) {
    final BaizeValue error = BaizeExceptionNatives.newExceptionNative(
      'BaizeInvalidBinaryOperation: $message',
      frame.getStackTrace(),
    );
    return handleError(error);
  }

  Future<BaizeInterpreterResult> handleError(final BaizeValue error) async {
    if (frame.tryFrames.isEmpty) {
      return BaizeInterpreterResult.fail(error);
    }
    final BaizeTryFrame tryFrame = frame.tryFrames.removeLast();
    final int scopeDiff = frame.scopeDepth - tryFrame.scopeDepth - 1;
    if (scopeDiff > 0) {
      for (int i = 0; i < scopeDiff; i++) {
        namespace = namespace.parent!;
      }
    }
    frame.ip = tryFrame.offset;
    stack.push(error);
    return interpret();
  }
}
