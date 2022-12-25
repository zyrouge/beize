import 'dart:async';
import '../bytecode/exports.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'stack.dart';

enum FubukiVMState {
  ready,
  running,
  finished,
}

typedef FubukiVMOnCallFinishFn = void Function();

class FubukiVM {
  FubukiVM(this.program);

  final FubukiFunctionConstant program;

  final FubukiStack stack = FubukiStack();
  final List<FubukiCallFrame> frames = <FubukiCallFrame>[];

  Future<void> run() async {
    final Completer<void> completer = Completer<void>();
    final FubukiCallFrame frame = FubukiCallFrame(
      vm: this,
      function: program,
      namespace: FubukiNamespace.withNatives(),
    );
    frames.add(frame);
    FubukiInterpreter(frame).run(
      // TODO: do this
      FubukiInterpreterCompleter(
        onComplete: (final _) {},
        onFail: (final _) {},
      ),
    );
    return completer.future;
  }

  void callValue(
    final FubukiValue value,
    final List<FubukiValue> arguments,
    final FubukiInterpreterCompleter completer,
  ) {
    if (value is FubukiFunctionValue) {
      return callFunctionValue(value, arguments, completer);
    }
    if (value is FubukiNativeFunctionValue) {
      return callNativeFunction(value, arguments, completer);
    }
    if (value is FubukiPrimitiveObjectValue) {
      final FubukiValue? callable = value.getOrNull(
        FubukiStringValue(FubukiPrimitiveObjectValue.kCallProperty),
      );
      if (callable != null) {
        return callValue(callable, arguments, completer);
      }
    }
    throw FubukiRuntimeExpection(
      'Value "${value.kToString()}" is not callable',
    );
  }

  void callNativeFunction(
    final FubukiNativeFunctionValue function,
    final List<FubukiValue> arguments,
    final FubukiInterpreterCompleter completer,
  ) {
    function.call(
      FubukiNativeFunctionCall(vm: this, arguments: arguments),
      completer,
    );
  }

  void callFunctionValue(
    final FubukiFunctionValue function,
    final List<FubukiValue> arguments,
    final FubukiInterpreterCompleter completer,
  ) {
    final FubukiNamespace namespace = function.namespace.enclosed;
    int i = 0;
    for (final String arg in function.constant.arguments) {
      final FubukiValue value =
          i < arguments.length ? arguments[i] : FubukiNullValue.value;
      namespace.declare(arg, value);
      i++;
    }
    final FubukiCallFrame frame = FubukiCallFrame(
      vm: this,
      function: function.constant,
      namespace: namespace,
    );
    frames.add(frame);
    FubukiInterpreter(frame).run(
      FubukiInterpreterCompleter(
        onComplete: (final FubukiValue result) {
          frames.removeLast();
          completer.complete(result);
        },
        onFail: (final FubukiValue result) {
          frames.removeLast();
          completer.fail(result);
        },
      ),
    );
  }
}

extension FubukiInterpreterValueUtils on FubukiValue {
  void callInVM(
    final FubukiVM vm,
    final List<FubukiValue> arguments,
    final FubukiInterpreterCompleter completer,
  ) =>
      vm.callValue(this, arguments, completer);
}
