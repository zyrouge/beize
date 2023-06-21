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
    this.printPrefix = 'print: ',
    this.onUnhandledException,
  });

  final bool disablePrint;
  final String printPrefix;
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
      0,
      isEntrypoint: true,
    );
    if (result.isFailure) {
      onUnhandledException(result.error);
    }
  }

  BeizePreparedModule prepareModule(
    final int moduleId, {
    required final bool isEntrypoint,
  }) {
    final String moduleName = program.moduleNameAt(moduleId);
    final BeizeNamespace namespace = globalNamespace.enclosed;
    final BeizeModuleValue value = BeizeModuleValue(namespace);
    modules[moduleName] = value;
    final BeizeCallFrame frame = BeizeCallFrame(
      vm: this,
      function: program.modules[moduleId],
      namespace: namespace,
      parent: !isEntrypoint ? topFrame : null,
    );
    if (isEntrypoint) topFrame = frame;
    return BeizePreparedModule(frame: frame, value: value);
  }

  BeizeInterpreterResult loadModule(
    final int moduleId, {
    final bool isEntrypoint = false,
  }) {
    final String moduleName = program.moduleNameAt(moduleId);
    if (modules.containsKey(moduleName)) {
      return BeizeInterpreterResult.success(modules[moduleName]!);
    }
    final BeizePreparedModule prepared = prepareModule(
      moduleId,
      isEntrypoint: isEntrypoint,
    );
    final BeizeInterpreterResult result =
        BeizeInterpreter(prepared.frame).run();
    if (result.isFailure) return result;
    return BeizeInterpreterResult.success(prepared.value);
  }

  Future<BeizeInterpreterResult> loadModuleAsync(
    final int moduleId, {
    final bool isEntrypoint = false,
  }) async {
    final String moduleName = program.moduleNameAt(moduleId);
    if (modules.containsKey(moduleName)) {
      return BeizeInterpreterResult.success(modules[moduleName]!);
    }
    final BeizePreparedModule prepared = prepareModule(
      moduleId,
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
