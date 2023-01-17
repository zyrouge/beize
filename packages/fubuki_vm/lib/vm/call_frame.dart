import 'dart:async';
import '../bytecode.dart';
import '../values/exports.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'natives/exports.dart';
import 'result.dart';
import 'stack.dart';
import 'try_frame.dart';
import 'vm.dart';

class FubukiCallFrame {
  FubukiCallFrame({
    required this.vm,
    required this.function,
    required this.namespace,
    this.parent,
  });

  int ip = 0;
  int sip = 0;
  int scopeDepth = 0;
  final List<FubukiTryFrame> tryFrames = <FubukiTryFrame>[];
  final FubukiStack stack = FubukiStack();

  final FubukiVM vm;
  final FubukiCallFrame? parent;
  final FubukiFunctionConstant function;
  final FubukiNamespace namespace;

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
        'Value "${value.kind.code}" is not callable',
        getStackTrace(),
      ),
    );
  }

  Future<FubukiInterpreterResult> callNativeFunction(
    final FubukiNativeFunctionValue function,
    final List<FubukiValue> arguments,
  ) async {
    final FubukiNativeFunctionCall call = FubukiNativeFunctionCall(
      frame: this,
      arguments: arguments,
    );
    final FubukiInterpreterResult result = await function.call(call);
    return result;
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
      vm: vm,
      parent: this,
      function: function.constant,
      namespace: namespace,
    );
    final FubukiInterpreterResult result = await FubukiInterpreter(frame).run();
    return result;
  }

  FubukiConstant readConstantAt(final int index) =>
      function.chunk.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine(final int depth) =>
      '#$depth   ${function.chunk.module} at line ${function.chunk.lineAt(sip)}';

  String getStackTrace([final int depth = 0]) {
    final String current = toStackTraceLine(depth);
    if (parent == null) return current;
    return '$current\n${parent!.getStackTrace(depth + 1)}';
  }
}
