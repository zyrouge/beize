import 'dart:async';
import '../bytecode/exports.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'natives/exports.dart';
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
      FubukiInterpreterCompleter(
        onComplete: (final _) {
          completer.complete();
        },
        onFail: (final FubukiValue value) {
          completer.completeError(FubukiUnhandledExpection(value.kToString()));
        },
      ),
    );
    return completer.future;
  }

  String getCurrentStackTrace() {
    final StringBuffer stackTrace = StringBuffer();
    int i = 0;
    for (final FubukiCallFrame x in frames.reversed) {
      stackTrace.writeln('#$i  at ${x.toStackTraceLine()}');
      i++;
    }
    return stackTrace.toString();
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
    completer.fail(
      FubukiExceptionNatives.newExceptionNative(
        'Value "${value.kToString()}" is not callable',
        getCurrentStackTrace(),
      ),
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

  Future<FubukiValue> callInVMAsync(
    final FubukiVM vm,
    final List<FubukiValue> arguments,
  ) {
    final Completer<FubukiValue> completer = Completer<FubukiValue>();
    vm.callValue(
      this,
      arguments,
      FubukiInterpreterCompleter(
        onComplete: completer.complete,
        onFail: completer.completeError,
      ),
    );
    return completer.future;
  }
}
