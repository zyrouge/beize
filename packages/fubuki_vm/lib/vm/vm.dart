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

  final FubukiProgramConstant program;

  final FubukiNamespace globalNamespace = FubukiNamespace.withNatives();
  final Map<String, FubukiModuleValue> modules = <String, FubukiModuleValue>{};
  final FubukiStack stack = FubukiStack();
  final List<FubukiCallFrame> frames = <FubukiCallFrame>[];

  Future<void> run() async {
    final Completer<void> completer = Completer<void>();
    loadModule(
      program.entrypoint,
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

  void loadModule(
    final String module,
    final FubukiInterpreterCompleter completer,
  ) {
    if (modules.containsKey(module)) {
      return completer.complete(modules[module]!);
    }
    final FubukiNamespace namespace = globalNamespace.enclosed;
    final FubukiModuleValue value = FubukiModuleValue(namespace);
    modules[module] = value;
    final FubukiCallFrame frame = FubukiCallFrame(
      vm: this,
      function: program.modules[module]!,
      namespace: namespace,
    );
    frames.add(frame);
    FubukiInterpreter(frame).run(
      FubukiInterpreterCompleter(
        onComplete: (final _) {
          frames.removeLast();
          completer.complete(value);
        },
        onFail: (final FubukiValue value) {
          frames.removeLast();
          completer.fail(value);
        },
      ),
    );
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
