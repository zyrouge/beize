import 'dart:math';
import '../bytecode/exports.dart';
import '../errors/exports.dart';
import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'try_frame.dart';
import 'vm.dart';

enum FubukiInterpreterState {
  ready,
  running,
  finished,
}

typedef FubukiInterpreterCompleterCallback = void Function(FubukiValue);

class FubukiInterpreterCompleter {
  const FubukiInterpreterCompleter({
    required this.onComplete,
    required this.onFail,
  });

  factory FubukiInterpreterCompleter.empty() => FubukiInterpreterCompleter(
        onComplete: (final _) {},
        onFail: (final _) {},
      );

  final FubukiInterpreterCompleterCallback onComplete;
  final FubukiInterpreterCompleterCallback onFail;

  void complete(final FubukiValue value) {
    onComplete(value);
  }

  void fail(final FubukiValue value) {
    onFail(value);
  }
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
  late FubukiInterpreterCompleter completer;

  void run(final FubukiInterpreterCompleter completer) {
    state = FubukiInterpreterState.running;
    this.completer = completer;
    next();
  }

  void next() {
    try {
      nextUnsafe();
    } catch (err) {
      propagateError(
        FubukiExceptionNatives.newExceptionNative(
          'FubukiRuntimeException: $err',
          vm.getCurrentStackTrace(),
        ),
      );
    }
  }

  void nextUnsafe() {
    if (frame.ip >= chunk.length) {
      state = FubukiInterpreterState.finished;
      completer.complete(resultValue);
      return;
    }

    final FubukiOpCodes opCode = chunk.opCodeAt(frame.ip);
    frame.ip++;
    switch (opCode) {
      case FubukiOpCodes.opBeginScope:
        frame.scopeDepth++;
        namespace = namespace.enclosed;
        return next();

      case FubukiOpCodes.opEndScope:
        frame.scopeDepth--;
        namespace = namespace.parent!;
        return next();

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
        return next();

      case FubukiOpCodes.opTrue:
        vm.stack.push(FubukiBooleanValue.trueValue);
        return next();

      case FubukiOpCodes.opFalse:
        vm.stack.push(FubukiBooleanValue.falseValue);
        return next();

      case FubukiOpCodes.opNull:
        vm.stack.push(FubukiNullValue.value);
        return next();

      case FubukiOpCodes.opPop:
        vm.stack.pop();
        return next();

      case FubukiOpCodes.opJumpIfFalse:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        if (vm.stack.top().isFalsey) {
          frame.ip += offset;
        }
        return next();

      case FubukiOpCodes.opJump:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip += offset + 1;
        return next();

      case FubukiOpCodes.opLoop:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip -= offset + 1;
        return next();

      case FubukiOpCodes.opCall:
        final int count = chunk.codeAt(frame.ip);
        frame.ip++;
        final List<FubukiValue> arguments =
            List<FubukiValue>.filled(count, FubukiNullValue.value);
        for (int i = count - 1; i >= 0; i--) {
          arguments[i] = vm.stack.pop();
        }
        final FubukiValue value = vm.stack.pop();
        return vm.callValue(
          value,
          arguments,
          FubukiInterpreterCompleter(
            onComplete: (final FubukiValue result) {
              vm.stack.push(result);
              next();
            },
            onFail: propagateError,
          ),
        );

      case FubukiOpCodes.opReturn:
        frame.ip = chunk.length;
        resultValue = vm.stack.pop();
        return next();

      case FubukiOpCodes.opPrint:
        print('print: ${vm.stack.pop().kToString()}');
        return next();

      case FubukiOpCodes.opNegate:
        vm.stack.push(vm.stack.pop<FubukiNumberValue>().negate);
        return next();

      case FubukiOpCodes.opEqual:
        final FubukiValue b = vm.stack.pop();
        final FubukiValue a = vm.stack.pop();
        vm.stack.push(FubukiBooleanValue(a.kHashCode == b.kHashCode));
        return next();

      case FubukiOpCodes.opNot:
        vm.stack.push(FubukiBooleanValue(!vm.stack.pop().isTruthy));
        return next();

      case FubukiOpCodes.opAdd:
        final FubukiValue b = vm.stack.pop();
        final FubukiValue a = vm.stack.pop();
        if (a is FubukiStringValue || b is FubukiStringValue) {
          vm.stack.push(FubukiStringValue(a.kToString() + b.kToString()));
        } else {
          vm.stack.push(
            FubukiNumberValue(
              a.cast<FubukiNumberValue>().value +
                  b.cast<FubukiNumberValue>().value,
            ),
          );
        }
        return next();

      case FubukiOpCodes.opSubtract:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiNumberValue(a.value - b.value));
        return next();

      case FubukiOpCodes.opMultiply:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiNumberValue(a.value * b.value));
        return next();

      case FubukiOpCodes.opDivide:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiNumberValue(a.value / b.value));
        return next();

      case FubukiOpCodes.opModulo:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiNumberValue(a.value % b.value));
        return next();

      case FubukiOpCodes.opExponent:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiNumberValue(pow(a.value, b.value).toDouble()));
        return next();

      case FubukiOpCodes.opLess:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiBooleanValue(a.value < b.value));
        return next();

      case FubukiOpCodes.opGreater:
        final FubukiNumberValue b = vm.stack.pop();
        final FubukiNumberValue a = vm.stack.pop();
        vm.stack.push(FubukiBooleanValue(a.value > b.value));
        return next();

      case FubukiOpCodes.opDeclare:
        final FubukiValue value = vm.stack.top();
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        namespace.declare(name, value);
        return next();

      case FubukiOpCodes.opAssign:
        final FubukiValue value = vm.stack.top();
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        namespace.assign(name, value);
        return next();

      case FubukiOpCodes.opLookup:
        final String name = frame.readConstantAt(frame.ip) as String;
        frame.ip++;
        vm.stack.push(namespace.lookup(name));
        return next();

      case FubukiOpCodes.opList:
        final int count = chunk.codeAt(frame.ip);
        frame.ip++;
        final List<FubukiValue> values =
            List<FubukiValue>.filled(count, FubukiNullValue.value);
        for (int i = count - 1; i >= 0; i--) {
          values[i] = vm.stack.pop();
        }
        vm.stack.push(FubukiListValue(values));
        return next();

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
        return next();

      case FubukiOpCodes.opGetProperty:
        final FubukiValue name = vm.stack.pop();
        final FubukiPrimitiveObjectValue obj = vm.stack.pop();
        final FubukiValue value = obj.get(name);
        vm.stack.push(value);
        return next();

      case FubukiOpCodes.opSetProperty:
        final FubukiValue value = vm.stack.pop();
        final FubukiValue name = vm.stack.pop();
        final FubukiPrimitiveObjectValue obj = vm.stack.pop();
        obj.set(name, value);
        vm.stack.push(value);
        return next();

      case FubukiOpCodes.opBeginTry:
        final int offset = chunk.codeAt(frame.ip);
        frame.ip++;
        frame.tryFrames.add(
          FubukiTryFrame(offset: offset, scopeDepth: frame.scopeDepth),
        );
        return next();

      case FubukiOpCodes.opEndTry:
        frame.tryFrames.removeLast();
        return next();

      case FubukiOpCodes.opThrow:
        return propagateError(vm.stack.pop());

      case FubukiOpCodes.opModule:
        final String module = frame.readConstantAt(frame.ip) as String;
        final String name = frame.readConstantAt(frame.ip + 1) as String;
        frame.ip += 2;
        return vm.loadModule(
          module,
          FubukiInterpreterCompleter(
            onComplete: (final FubukiValue value) {
              namespace.declare(name, value);
              next();
            },
            onFail: propagateError,
          ),
        );

      default:
        throw FubukiRuntimeExpection.unknownOpCode(opCode);
    }
  }

  void propagateError(final FubukiValue error) {
    if (frame.tryFrames.isEmpty) {
      completer.fail(error);
      return;
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
    next();
  }
}
