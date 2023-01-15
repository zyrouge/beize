import 'dart:async';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'result.dart';
import 'stack.dart';

enum FubukiVMState {
  ready,
  running,
  finished,
}

class FubukiVMOptions {
  FubukiVMOptions({
    this.disablePrint = false,
  });

  final bool disablePrint;
}

class FubukiVM {
  FubukiVM(this.program, this.options);

  final FubukiProgramConstant program;
  final FubukiVMOptions options;

  final FubukiNamespace globalNamespace = FubukiNamespace.withNatives();
  final Map<String, FubukiModuleValue> modules = <String, FubukiModuleValue>{};
  final FubukiStack stack = FubukiStack();
  final List<FubukiCallFrame> frames = <FubukiCallFrame>[];
  final void Function(FubukiValue)? onUncaughtError = null;

  Future<void> run() async {
    final FubukiInterpreterResult result = await loadModule(program.entrypoint);
    if (result.isFailure) {
      throw FubukiUnhandledExpection(result.value.kToString());
    }
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

  Future<FubukiInterpreterResult> loadModule(final String module) async {
    if (modules.containsKey(module)) {
      return FubukiInterpreterResult.success(modules[module]!);
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
    final FubukiInterpreterResult result = await FubukiInterpreter(frame).run();
    frames.removeLast();
    if (result.isFailure) return result;
    return FubukiInterpreterResult.success(value);
  }

  Future<FubukiInterpreterResult> callValue(
    final FubukiValue value,
    final List<FubukiValue> arguments,
  ) async {
    if (value is FubukiFunctionValue) {
      return callFunctionValue(value, arguments);
    }
    if (value is FubukiNativeFunctionValue) {
      return callNativeFunction(value, arguments);
    }
    return FubukiInterpreterResult.fail(
      FubukiExceptionNatives.newExceptionNative(
        'Value "${value.kToString()}" is not callable',
        getCurrentStackTrace(),
      ),
    );
  }

  Future<FubukiInterpreterResult> callNativeFunction(
    final FubukiNativeFunctionValue function,
    final List<FubukiValue> arguments,
  ) {
    final FubukiNativeFunctionCall call = FubukiNativeFunctionCall(
      vm: this,
      arguments: arguments,
    );
    return function.call(call);
  }

  Future<FubukiInterpreterResult> callFunctionValue(
    final FubukiFunctionValue function,
    final List<FubukiValue> arguments,
  ) async {
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
    final FubukiInterpreterResult result = await FubukiInterpreter(frame).run();
    frames.removeLast();
    return result;
  }
}

extension FubukiInterpreterValueUtils on FubukiFunctionValue {
  Future<FubukiInterpreterResult> callInVM(
    final FubukiVM vm,
    final List<FubukiValue> arguments,
  ) =>
      vm.callValue(this, arguments);
}
