import 'dart:async';
import '../bytecode.dart';
import '../values/exports.dart';
import 'interpreter.dart';
import 'namespace.dart';
import 'result.dart';
import 'try_frame.dart';
import 'vm.dart';

class BeizeCallFrame {
  BeizeCallFrame({
    required this.vm,
    required this.function,
    required this.namespace,
    this.parent,
  });

  int ip = 0;
  int sip = 0;
  int scopeDepth = 0;
  final List<BeizeTryFrame> tryFrames = <BeizeTryFrame>[];

  final BeizeVM vm;
  final BeizeCallFrame? parent;
  final BeizeFunctionConstant function;
  final BeizeNamespace namespace;

  Future<BeizeInterpreterResult> callValue(
    final BeizeValue value,
    final List<BeizeValue> arguments,
  ) async {
    if (value is BeizeFunctionValue) {
      return callFunctionValue(value, arguments);
    }
    if (value is BeizeNativeFunctionValue) {
      return callNativeFunction(value, arguments);
    }
    return BeizeInterpreterResult.fail(
      BeizeExceptionValue(
        'Value "${value.kind.code}" is not callable',
        getStackTrace(),
      ),
    );
  }

  Future<BeizeInterpreterResult> callNativeFunction(
    final BeizeNativeFunctionValue function,
    final List<BeizeValue> arguments,
  ) async {
    final BeizeNativeFunctionCall call = BeizeNativeFunctionCall(
      frame: this,
      arguments: arguments,
    );
    final BeizeInterpreterResult result = await function.call(call);
    return result;
  }

  Future<BeizeInterpreterResult> callFunctionValue(
    final BeizeFunctionValue function,
    final List<BeizeValue> arguments,
  ) async {
    final BeizeNamespace namespace = function.namespace.enclosed;
    int i = 0;
    for (final String arg in function.constant.arguments) {
      final BeizeValue value =
          i < arguments.length ? arguments[i] : BeizeNullValue.value;
      namespace.declare(arg, value);
      i++;
    }
    final BeizeCallFrame frame = BeizeCallFrame(
      vm: vm,
      parent: this,
      function: function.constant,
      namespace: namespace,
    );
    final BeizeInterpreterResult result = await BeizeInterpreter(frame).run();
    return result;
  }

  BeizeConstant readConstantAt(final int index) =>
      function.chunk.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine(final int depth) =>
      '#$depth   ${function.chunk.module} at line ${function.chunk.lineAt(sip)}';

  String getStackTrace([final int depth = 0]) {
    final String current = toStackTraceLine(depth);
    if (parent == null) return current;
    return '$current\n${parent!.getStackTrace(depth + 1)}';
  }
}
