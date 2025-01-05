import '../../bytecode.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class BeizeFunctionValue extends BeizePrimitiveObjectValue
    implements BeizeCallableValue {
  BeizeFunctionValue({
    required this.constant,
    required this.namespace,
  });

  final BeizeFunctionConstant constant;
  final BeizeNamespace namespace;

  @override
  final String kName = 'Function';

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    if (!constant.isAsync) {
      final BeizeCallFrame frame =
          call.frame.prepareCallFunctionValue(call.arguments, this);
      return BeizeInterpreter(frame).run();
    }
    final BeizeUnawaitedValue value = BeizeUnawaitedValue(
      call.arguments,
      (final BeizeFunctionCall nCall) async {
        final BeizeCallFrame frame =
            nCall.frame.prepareCallFunctionValue(nCall.arguments, this);
        final BeizeInterpreterResult result =
            await BeizeInterpreter(frame).runAsync();
        return result;
      },
    );
    return BeizeInterpreterResult.success(value);
  }

  @override
  BeizeFunctionClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.functionClass;

  @override
  BeizeFunctionValue kClone() =>
      BeizeFunctionValue(constant: constant, namespace: namespace);

  @override
  String kToString() => '<function>';

  bool get isAsync => constant.isAsync;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
