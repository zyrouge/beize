import '../bytecode.dart';
import '../values/exports.dart';
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

  BeizeInterpreterResult callValue(
    final BeizeValue value,
    final List<BeizeValue> arguments,
  ) {
    if (value is BeizeCallableValue) {
      final BeizeFunctionCall call = BeizeFunctionCall(
        frame: this,
        arguments: arguments,
      );
      return value.kCall(call);
    }
    return BeizeInterpreterResult.fail(
      BeizeExceptionValue(
        'BeizeRuntimeException: Value "${value.kName}" is not callable',
        getStackTrace(),
      ),
    );
  }

  BeizeCallFrame prepareCallFunctionValue(
    final List<BeizeValue> arguments,
    final BeizeFunctionValue function,
  ) {
    final BeizeNamespace namespace = function.namespace.enclosed;
    int i = 0;
    for (final int argIndex in function.constant.arguments) {
      final String argName = vm.program.constantAt(argIndex) as String;
      final BeizeValue value =
          i < arguments.length ? arguments[i] : BeizeNullValue.value;
      namespace.declare(argName, value);
      i++;
    }
    final BeizeCallFrame frame = BeizeCallFrame(
      vm: vm,
      parent: this,
      function: function.constant,
      namespace: namespace,
    );
    return frame;
  }

  BeizeConstant readConstantAt(final int index) =>
      vm.program.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine(final int depth) {
    final String moduleName = vm.program.moduleNameAt(function.moduleIndex);
    final int line = function.chunk.lineAt(sip);
    return '#$depth   $moduleName at line $line';
  }

  String getStackTrace([final int depth = 0]) {
    final String current = toStackTraceLine(depth);
    if (parent == null) return current;
    return '$current\n${parent!.getStackTrace(depth + 1)}';
  }

  static BeizeInterpreterResult kCallValueFrameless(
    final BeizeVM vm,
    final BeizeValue value,
  ) {
    if (value is BeizeFunctionValue) {
      final BeizeFunctionCall call = BeizeFunctionCall(
        frame: BeizeCallFrame(
          vm: vm,
          function: value.constant,
          namespace: value.namespace,
        ),
        arguments: <BeizeValue>[],
      );
      return value.kCall(call);
    }
    if (value is BeizeCallableValue) {
      // TODO: make this better
      final BeizeFunctionCall call = BeizeFunctionCall(
        frame: BeizeCallFrame(
          vm: vm,
          function: BeizeFunctionConstant(
            moduleIndex: -1,
            isAsync: false,
            arguments: List<int>.empty(),
            chunk: BeizeChunk.empty(),
          ),
          namespace: BeizeNamespace(),
        ),
        arguments: <BeizeValue>[],
      );
      return value.kCall(call);
    }
    return BeizeInterpreterResult.fail(
      BeizeExceptionValue(
        'BeizeRuntimeException: Value "${value.kName}" is not callable',
        '<suspended>',
        StackTrace.current.toString(),
      ),
    );
  }
}
