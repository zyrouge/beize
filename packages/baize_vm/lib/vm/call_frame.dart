import 'dart:async';
import '../bytecode.dart';
import '../values/exports.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'result.dart';
import 'try_frame.dart';
import 'vm.dart';

class BaizeCallFrame {
  BaizeCallFrame({
    required this.vm,
    required this.function,
    required this.namespace,
    this.parent,
  });

  int ip = 0;
  int sip = 0;
  int scopeDepth = 0;
  final List<BaizeTryFrame> tryFrames = <BaizeTryFrame>[];

  final BaizeVM vm;
  final BaizeCallFrame? parent;
  final BaizeFunctionConstant function;
  final BaizeNamespace namespace;

  Future<BaizeInterpreterResult> callValue(
    final BaizeValue value,
    final List<BaizeValue> arguments,
  ) async {
    if (value is BaizeFunctionValue) {
      return callFunctionValue(value, arguments);
    }
    if (value is BaizeNativeFunctionValue) {
      return callNativeFunction(value, arguments);
    }
    return BaizeInterpreterResult.fail(
      BaizeExceptionNatives.newExceptionNative(
        'Value "${value.kind.code}" is not callable',
        getStackTrace(),
      ),
    );
  }

  Future<BaizeInterpreterResult> callNativeFunction(
    final BaizeNativeFunctionValue function,
    final List<BaizeValue> arguments,
  ) async {
    final BaizeNativeFunctionCall call = BaizeNativeFunctionCall(
      frame: this,
      arguments: arguments,
    );
    final BaizeInterpreterResult result = await function.call(call);
    return result;
  }

  Future<BaizeInterpreterResult> callFunctionValue(
    final BaizeFunctionValue function,
    final List<BaizeValue> arguments,
  ) async {
    final BaizeNamespace namespace = function.namespace.enclosed;
    int i = 0;
    for (final String arg in function.constant.arguments) {
      final BaizeValue value =
          i < arguments.length ? arguments[i] : BaizeNullValue.value;
      namespace.declare(arg, value);
      i++;
    }
    final BaizeCallFrame frame = BaizeCallFrame(
      vm: vm,
      parent: this,
      function: function.constant,
      namespace: namespace,
    );
    final BaizeInterpreterResult result = await BaizeInterpreter(frame).run();
    return result;
  }

  BaizeConstant readConstantAt(final int index) =>
      function.chunk.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine(final int depth) =>
      '#$depth   ${function.chunk.module} at line ${function.chunk.lineAt(sip)}';

  String getStackTrace([final int depth = 0]) {
    final String current = toStackTraceLine(depth);
    if (parent == null) return current;
    return '$current\n${parent!.getStackTrace(depth + 1)}';
  }
}
