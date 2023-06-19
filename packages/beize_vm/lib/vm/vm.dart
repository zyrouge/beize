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
    final BeizeInterpreterResult result = await loadModuleAsync(
      program.entrypoint,
      isEntrypoint: true,
    );
    if (result.isFailure) {
      onUnhandledException(result.error);
    }
  }

  BeizePreparedModule prepareModule(
    final String module, {
    required final bool isEntrypoint,
  }) {
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
    return BeizePreparedModule(frame: frame, value: value);
  }

  BeizeInterpreterResult loadModule(
    final String module, {
    final bool isEntrypoint = false,
  }) {
    if (modules.containsKey(module)) {
      return BeizeInterpreterResult.success(modules[module]!);
    }
    final BeizePreparedModule prepared = prepareModule(
      module,
      isEntrypoint: isEntrypoint,
    );
    final BeizeInterpreterResult result =
        BeizeInterpreter(prepared.frame).run();
    if (result.isFailure) return result;
    return BeizeInterpreterResult.success(prepared.value);
  }

  Future<BeizeInterpreterResult> loadModuleAsync(
    final String module, {
    final bool isEntrypoint = false,
  }) async {
    if (modules.containsKey(module)) {
      return BeizeInterpreterResult.success(modules[module]!);
    }
    final BeizePreparedModule prepared = prepareModule(
      module,
      isEntrypoint: isEntrypoint,
    );
    final BeizeInterpreterResult result =
        await BeizeInterpreter(prepared.frame).runAsync();
    if (result.isFailure) return result;
    return BeizeInterpreterResult.success(prepared.value);
  }

  void onUnhandledException(final BeizeExceptionValue err) {
    if (options.onUnhandledException != null) {
      options.onUnhandledException!.call(err);
      return;
    }
    throw BeizeUnhandledExpection(err.toCustomString(includePrefix: false));
  }
}

class BeizePreparedModule {
  const BeizePreparedModule({
    required this.frame,
    required this.value,
  });

  final BeizeCallFrame frame;
  final BeizeModuleValue value;
}
