import 'dart:async';
import '../bytecode.dart';
import '../errors/exports.dart';
import '../values/exports.dart';
import 'call_frame.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'result.dart';

enum BaizeVMState {
  ready,
  running,
  finished,
}

typedef BaizeVMOnUncaughtError = void Function(BaizeValue);

class BaizeVMOptions {
  BaizeVMOptions({
    this.disablePrint = false,
    this.onUnhandledException,
  });

  final bool disablePrint;
  final BaizeVMOnUncaughtError? onUnhandledException;
}

class BaizeVM {
  BaizeVM(this.program, this.options);

  final BaizeProgramConstant program;
  final BaizeVMOptions options;

  final BaizeNamespace globalNamespace = BaizeNamespace.withNatives();
  final Map<String, BaizeModuleValue> modules = <String, BaizeModuleValue>{};
  late final BaizeCallFrame topFrame;

  Future<void> run() async {
    final BaizeInterpreterResult result = await loadModule(
      program.entrypoint,
      isEntrypoint: true,
    );
    if (result.isFailure) {
      onUnhandledException(result.value);
    }
  }

  Future<BaizeInterpreterResult> loadModule(
    final String module, {
    final bool isEntrypoint = false,
  }) async {
    if (modules.containsKey(module)) {
      return BaizeInterpreterResult.success(modules[module]!);
    }
    final BaizeNamespace namespace = globalNamespace.enclosed;
    final BaizeModuleValue value = BaizeModuleValue(namespace);
    modules[module] = value;
    final BaizeCallFrame frame = BaizeCallFrame(
      vm: this,
      function: program.modules[module]!,
      namespace: namespace,
      parent: !isEntrypoint ? topFrame : null,
    );
    if (isEntrypoint) topFrame = frame;
    final BaizeInterpreterResult result = await BaizeInterpreter(frame).run();
    if (result.isFailure) return result;
    return BaizeInterpreterResult.success(value);
  }

  void onUnhandledException(final BaizeValue err) {
    if (options.onUnhandledException != null) {
      options.onUnhandledException!.call(err);
      return;
    }
    throw BaizeUnhandledExpection(err.kToString());
  }
}
