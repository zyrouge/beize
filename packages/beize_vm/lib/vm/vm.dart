import 'dart:async';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'globals.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'result.dart';

enum BeizeVMState {
  ready,
  running,
  finished,
}

typedef BeizeVMOnUncaughtException = void Function(BeizeExceptionValue);
typedef BeizeVMOnPrint = void Function(String);

class BeizeVMOptions {
  BeizeVMOptions({
    this.disablePrint = false,
    this.printPrefix = 'print: ',
    this.onUnhandledException,
    this.onPrint,
  });

  final bool disablePrint;
  final String printPrefix;
  final BeizeVMOnUncaughtException? onUnhandledException;
  final BeizeVMOnPrint? onPrint;
}

class BeizeVM {
  BeizeVM(this.program, this.options) {
    globals.bind(globalNamespace);
    BeizeNatives.bind(globalNamespace);
  }

  final BeizeProgramConstant program;
  final BeizeVMOptions options;

  final BeizeGlobals globals = BeizeGlobals();
  final BeizeNamespace globalNamespace = BeizeNamespace();
  final Map<int, BeizeModuleValue> modules = <int, BeizeModuleValue>{};
  late final BeizeCallFrame topFrame;

  Future<void> run() async {
    final BeizePreparedModule prepared = prepareModule(
      0,
      isEntrypoint: true,
    );
    final BeizeInterpreterResult result = await loadModuleAsync(prepared);
    if (result.isFailure) {
      onUnhandledException(result.error);
    }
  }

  BeizeModuleValue? lookupModule(final int moduleIndex) => modules[moduleIndex];

  BeizePreparedModule prepareModule(
    final int moduleIndex, {
    required final bool isEntrypoint,
  }) {
    final BeizeNamespace namespace = globalNamespace.enclosed;
    final BeizeModuleValue value = BeizeModuleValue(namespace);
    modules[moduleIndex] = value;
    final BeizeCallFrame frame = BeizeCallFrame(
      vm: this,
      function: program.moduleFunctionAt(moduleIndex),
      namespace: namespace,
      parent: !isEntrypoint ? topFrame : null,
    );
    if (isEntrypoint) {
      topFrame = frame;
    }
    return BeizePreparedModule(
      moduleIndex: moduleIndex,
      frame: frame,
      value: value,
    );
  }

  BeizeInterpreterResult loadModule(final BeizePreparedModule module) {
    final BeizeInterpreterResult result = BeizeInterpreter(module.frame).run();
    if (result.isFailure) return result;
    return BeizeInterpreterResult.success(module.value);
  }

  Future<BeizeInterpreterResult> loadModuleAsync(
    final BeizePreparedModule module,
  ) async {
    final BeizeInterpreterResult result =
        await BeizeInterpreter(module.frame).runAsync();
    if (result.isFailure) return result;
    return BeizeInterpreterResult.success(module.value);
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
    required this.moduleIndex,
    required this.frame,
    required this.value,
  });

  final int moduleIndex;
  final BeizeCallFrame frame;
  final BeizeModuleValue value;
}
