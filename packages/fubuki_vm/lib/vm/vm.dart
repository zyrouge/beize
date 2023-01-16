import 'dart:async';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'result.dart';
import 'stack.dart';

enum FubukiVMState {
  ready,
  running,
  finished,
}

typedef FubukiVMOnUncaughtError = void Function(FubukiValue);

class FubukiVMOptions {
  FubukiVMOptions({
    this.disablePrint = false,
    this.onUnhandledException,
  });

  final bool disablePrint;
  final FubukiVMOnUncaughtError? onUnhandledException;
}

class FubukiVM {
  FubukiVM(this.program, this.options);

  final FubukiProgramConstant program;
  final FubukiVMOptions options;

  final FubukiNamespace globalNamespace = FubukiNamespace.withNatives();
  final Map<String, FubukiModuleValue> modules = <String, FubukiModuleValue>{};
  final FubukiStack stack = FubukiStack();
  late final FubukiCallFrame topFrame;

  Future<void> run() async {
    final FubukiInterpreterResult result = await loadModule(
      program.entrypoint,
      isEntrypoint: true,
    );
    if (result.isFailure) {
      onUnhandledException(result.value);
    }
  }

  Future<FubukiInterpreterResult> loadModule(
    final String module, {
    final bool isEntrypoint = false,
  }) async {
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
      parent: !isEntrypoint ? topFrame : null,
    );
    if (isEntrypoint) topFrame = frame;
    final FubukiInterpreterResult result = await FubukiInterpreter(frame).run();
    if (result.isFailure) return result;
    return FubukiInterpreterResult.success(value);
  }

  void onUnhandledException(final FubukiValue err) {
    if (options.onUnhandledException != null) {
      options.onUnhandledException!.call(err);
      return;
    }
    throw FubukiUnhandledExpection(err.kToString());
  }
}
