import 'dart:async';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'result.dart';

enum BeizeVMState {
  ready,
  running,
  finished,
}

typedef BeizeVMOnUncaughtException = void Function(BeizeExceptionValue);

class BeizeVMOptions {
  BeizeVMOptions({
    this.disablePrint = false,
    this.onUnhandledException,
  });

  final bool disablePrint;
  final BeizeVMOnUncaughtException? onUnhandledException;
}

class BeizeVM {
  BeizeVM(this.program, this.options);

  final BeizeProgramConstant program;
  final BeizeVMOptions options;

  final BeizeNamespace globalNamespace = BeizeNamespace.withNatives();
  final Map<String, BeizeModuleValue> modules = <String, BeizeModuleValue>{};
  late final BeizeCallFrame topFrame;

  Future<void> run() async {
    final BeizeInterpreterResult result = await loadModule(
      program.entrypoint,
      isEntrypoint: true,
    );
    if (result.isFailure) {
      onUnhandledException(result.error);
    }
  }

  Future<BeizeInterpreterResult> loadModule(
    final String module, {
    final bool isEntrypoint = false,
  }) async {
    if (modules.containsKey(module)) {
      return BeizeInterpreterResult.success(modules[module]!);
    }
    final BeizeNamespace namespace = globalNamespace.enclosed;
    final BeizeModuleValue value = BeizeModuleValue(namespace);
    modules[module] = value;
    final BeizeCallFrame frame = BeizeCallFrame(
      vm: this,
      function: program.modules[module]!,
      namespace: namespace,
      parent: !isEntrypoint ? topFrame : null,
    );
    if (isEntrypoint) topFrame = frame;
    final BeizeInterpreterResult result = await BeizeInterpreter(frame).run();
    if (result.isFailure) return result;
    return BeizeInterpreterResult.success(value);
  }

  void onUnhandledException(final BeizeExceptionValue err) {
    if (options.onUnhandledException != null) {
      options.onUnhandledException!.call(err);
      return;
    }
    throw BeizeUnhandledExpection(err.toCustomString(includePrefix: false));
  }
}
