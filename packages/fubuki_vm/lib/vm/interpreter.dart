import 'dart:math';
import '../bytecode/exports.dart';
import '../errors/exports.dart';
import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'result.dart';
import 'try_frame.dart';
import 'vm.dart';

enum FubukiInterpreterState {
  ready,
  running,
  finished,
}

class FubukiInterpreter {
  FubukiInterpreter(this.frame)
      : vm = frame.vm,
        chunk = frame.function.chunk,
        namespace = frame.namespace;

  final FubukiVM vm;
  final FubukiCallFrame frame;
  final FubukiChunk chunk;
  FubukiNamespace namespace;

  FubukiInterpreterState state = FubukiInterpreterState.ready;
  FubukiValue resultValue = FubukiNullValue.value;

  Future<FubukiInterpreterResult> run() async {
    state = FubukiInterpreterState.running;
    try {
      final FubukiInterpreterResult result = await interpret();
      return result;
    } catch (err, stackTrace) {
      return FubukiInterpreterResult.fail(
        FubukiExceptionNatives.newExceptionNative(
          'FubukiRuntimeException: $err',
          '${vm.getCurrentStackTrace()}\nDart Stack Trace:\n$stackTrace',
        ),
      );
    }
  }

  Future<FubukiInterpreterResult> interpret() async {
    while (frame.ip < chunk.length) {
      final FubukiOpCodes opCode = chunk.opCodeAt(frame.ip);
      frame.sip = frame.ip;
      frame.ip++;
      switch (opCode) {
        case FubukiOpCodes.opBeginScope:
          frame.scopeDepth++;
          namespace = namespace.enclosed;
          break;

        case FubukiOpCodes.opEndScope:
          frame.scopeDepth--;
          namespace = namespace.parent!;
          break;

        case FubukiOpCodes.opConstant:
          final FubukiConstant constant = frame.readConstantAt(frame.ip);
          final FubukiValue value;
          if (constant is FubukiFunctionConstant) {
            value = FubukiFunctionValue(
              constant: constant,
              namespace: namespace,
            );
          } else if (constant is double) {
            value = FubukiNumberValue(constant);
          } else if (constant is String) {
            value = FubukiStringValue(constant);
          } else {
            throw FubukiRuntimeExpection.unknownConstant(constant);
          }
          vm.stack.push(value);
          frame.ip++;
          break;

        case FubukiOpCodes.opTrue:
          vm.stack.push(FubukiBooleanValue.trueValue);
          break;

        case FubukiOpCodes.opFalse:
          vm.stack.push(FubukiBooleanValue.falseValue);
          break;

        case FubukiOpCodes.opNull:
          vm.stack.push(FubukiNullValue.value);
          break;

        case FubukiOpCodes.opPop:
          vm.stack.pop();
          break;

        case FubukiOpCodes.opJumpIfNull:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip++;
          if (vm.stack.top() is FubukiNullValue) {
            frame.ip += offset;
          }
          break;

        case FubukiOpCodes.opJumpIfFalse:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip++;
          if (vm.stack.top().isFalsey) {
            frame.ip += offset;
          }
          break;

        case FubukiOpCodes.opJump:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip += offset + 1;
          break;

        case FubukiOpCodes.opLoop:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip -= offset + 1;
          break;

        case FubukiOpCodes.opCall:
          final int count = chunk.codeAt(frame.ip);
          frame.ip++;
          final List<FubukiValue> arguments =
              List<FubukiValue>.filled(count, FubukiNullValue.value);
          for (int i = count - 1; i >= 0; i--) {
            arguments[i] = vm.stack.pop();
          }
          final FubukiValue value = vm.stack.pop();
          final FubukiInterpreterResult result =
              await vm.callValue(value, arguments);
          if (result.isFailure) {
            return handleError(result.value);
          }
          vm.stack.push(result.value);
          break;

        case FubukiOpCodes.opReturn:
          frame.ip = chunk.length;
          resultValue = vm.stack.pop();
          break;

        case FubukiOpCodes.opPrint:
          print('print: ${vm.stack.pop().kToString()}');
          break;

        case FubukiOpCodes.opNegate:
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue) {
            return handleInvalidUnary(
              'Cannot perform negate on "${a.kind.code}"',
            );
          }
          vm.stack.push(a.negate);
          break;

        case FubukiOpCodes.opBitwiseNot:
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue) {
            return handleInvalidUnary(
              'Cannot perform bitwise not on "${a.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue((~a.unsafeIntValue).toDouble()));
          break;

        case FubukiOpCodes.opEqual:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          vm.stack.push(FubukiBooleanValue(a.kHashCode == b.kHashCode));
          break;

        case FubukiOpCodes.opNot:
          vm.stack.push(FubukiBooleanValue(!vm.stack.pop().isTruthy));
          break;

        case FubukiOpCodes.opAdd:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is FubukiStringValue || b is FubukiStringValue) {
            vm.stack.push(FubukiStringValue(a.kToString() + b.kToString()));
          } else if (a is FubukiNumberValue && b is FubukiNumberValue) {
            vm.stack.push(FubukiNumberValue(a.value + b.value));
          } else {
            return handleInvalidBinary(
              'Cannot perform addition between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case FubukiOpCodes.opSubtract:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform subtraction between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue(a.value - b.value));
          break;

        case FubukiOpCodes.opMultiply:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform multiplication between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue(a.value * b.value));
          break;

        case FubukiOpCodes.opDivide:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform division between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue(a.value / b.value));
          break;

        case FubukiOpCodes.opFloor:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform floor division between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue((a.value ~/ b.value).toDouble()));
          break;

        case FubukiOpCodes.opModulo:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform remainder between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue(a.value % b.value));
          break;

        case FubukiOpCodes.opExponent:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform exponentiation between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiNumberValue(pow(a.value, b.value).toDouble()));
          break;

        case FubukiOpCodes.opIncrement:
          final FubukiNumberValue a = vm.stack.pop();
          vm.stack.push(FubukiNumberValue(a.value + 1));
          break;

        case FubukiOpCodes.opDecrement:
          final FubukiNumberValue a = vm.stack.pop();
          vm.stack.push(FubukiNumberValue(a.value - 1));
          break;

        case FubukiOpCodes.opLess:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform comparison between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiBooleanValue(a.value < b.value));
          break;

        case FubukiOpCodes.opGreater:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is! FubukiNumberValue || b is! FubukiNumberValue) {
            return handleInvalidBinary(
              'Cannot perform comparison between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          vm.stack.push(FubukiBooleanValue(a.value > b.value));
          break;

        case FubukiOpCodes.opBitwiseAnd:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is FubukiBooleanValue && b is FubukiBooleanValue) {
            vm.stack.push(FubukiBooleanValue(a.value & b.value));
          } else if (a is FubukiNumberValue && b is FubukiNumberValue) {
            vm.stack.push(
              FubukiNumberValue(
                (a.unsafeIntValue & b.unsafeIntValue).toDouble(),
              ),
            );
          } else {
            return handleInvalidBinary(
              'Cannot perform bitwise AND between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case FubukiOpCodes.opBitwiseOr:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is FubukiBooleanValue && b is FubukiBooleanValue) {
            vm.stack.push(FubukiBooleanValue(a.value | b.value));
          } else if (a is FubukiNumberValue && b is FubukiNumberValue) {
            vm.stack.push(
              FubukiNumberValue((a.intValue | b.intValue).toDouble()),
            );
          } else {
            return handleInvalidBinary(
              'Cannot perform bitwise OR between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case FubukiOpCodes.opBitwiseXor:
          final FubukiValue b = vm.stack.pop();
          final FubukiValue a = vm.stack.pop();
          if (a is FubukiBooleanValue && b is FubukiBooleanValue) {
            vm.stack.push(FubukiBooleanValue(a.value ^ b.value));
          } else if (a is FubukiNumberValue && b is FubukiNumberValue) {
            vm.stack.push(
              FubukiNumberValue((a.intValue ^ b.intValue).toDouble()),
            );
          } else {
            return handleInvalidBinary(
              'Cannot perform bitwise XOR between "${a.kind.code}" and "${b.kind.code}"',
            );
          }
          break;

        case FubukiOpCodes.opDeclare:
          final FubukiValue value = vm.stack.top();
          final String name = frame.readConstantAt(frame.ip) as String;
          frame.ip++;
          namespace.declare(name, value);
          break;

        case FubukiOpCodes.opAssign:
          final FubukiValue value = vm.stack.top();
          final String name = frame.readConstantAt(frame.ip) as String;
          frame.ip++;
          namespace.assign(name, value);
          break;

        case FubukiOpCodes.opLookup:
          final String name = frame.readConstantAt(frame.ip) as String;
          frame.ip++;
          vm.stack.push(namespace.lookup(name));
          break;

        case FubukiOpCodes.opList:
          final int count = chunk.codeAt(frame.ip);
          frame.ip++;
          final List<FubukiValue> values =
              List<FubukiValue>.filled(count, FubukiNullValue.value);
          for (int i = count - 1; i >= 0; i--) {
            values[i] = vm.stack.pop();
          }
          vm.stack.push(FubukiListValue(values));
          break;

        case FubukiOpCodes.opObject:
          final int count = chunk.codeAt(frame.ip);
          frame.ip++;
          final FubukiObjectValue obj = FubukiObjectValue();
          for (int i = 0; i < count; i++) {
            final FubukiValue value = vm.stack.pop();
            final FubukiValue key = vm.stack.pop();
            obj.set(key, value);
          }
          vm.stack.push(obj);
          break;

        case FubukiOpCodes.opGetProperty:
          final FubukiValue name = vm.stack.pop();
          final FubukiPrimitiveObjectValue obj = vm.stack.pop();
          final FubukiValue value = obj.get(name);
          vm.stack.push(value);
          break;

        case FubukiOpCodes.opSetProperty:
          final FubukiValue value = vm.stack.pop();
          final FubukiValue name = vm.stack.pop();
          final FubukiPrimitiveObjectValue obj = vm.stack.pop();
          obj.set(name, value);
          vm.stack.push(value);
          break;

        case FubukiOpCodes.opBeginTry:
          final int offset = chunk.codeAt(frame.ip);
          frame.ip++;
          frame.tryFrames.add(
            FubukiTryFrame(offset: offset, scopeDepth: frame.scopeDepth),
          );
          break;

        case FubukiOpCodes.opEndTry:
          frame.tryFrames.removeLast();
          break;

        case FubukiOpCodes.opThrow:
          return handleError(vm.stack.pop());

        case FubukiOpCodes.opModule:
          final String module = frame.readConstantAt(frame.ip) as String;
          final String name = frame.readConstantAt(frame.ip + 1) as String;
          frame.ip += 2;
          final FubukiInterpreterResult result = await vm.loadModule(module);
          if (result.isFailure) {
            return handleError(result.value);
          }
          namespace.declare(name, result.value);
          break;

        default:
          throw FubukiRuntimeExpection.unknownOpCode(opCode);
      }
    }

    state = FubukiInterpreterState.finished;
    return FubukiInterpreterResult.success(resultValue);
  }

  Future<FubukiInterpreterResult> handleInvalidUnary(final String message) {
    final FubukiValue error = FubukiExceptionNatives.newExceptionNative(
      'FubukiInvalidUnaryOperation: $message',
      vm.getCurrentStackTrace(),
    );
    return handleError(error);
  }

  Future<FubukiInterpreterResult> handleInvalidBinary(final String message) {
    final FubukiValue error = FubukiExceptionNatives.newExceptionNative(
      'FubukiInvalidBinaryOperation: $message',
      vm.getCurrentStackTrace(),
    );
    return handleError(error);
  }

  Future<FubukiInterpreterResult> handleError(final FubukiValue error) async {
    if (frame.tryFrames.isEmpty) {
      return FubukiInterpreterResult.fail(error);
    }
    final FubukiTryFrame tryFrame = frame.tryFrames.removeLast();
    final int scopeDiff = frame.scopeDepth - tryFrame.scopeDepth - 1;
    if (scopeDiff > 0) {
      for (int i = 0; i < scopeDiff; i++) {
        namespace = namespace.parent!;
      }
    }
    frame.ip = tryFrame.offset;
    vm.stack.push(error);
    return interpret();
  }
}
