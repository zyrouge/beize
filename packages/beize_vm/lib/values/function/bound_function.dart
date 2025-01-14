import '../../vm/exports.dart';
import '../exports.dart';

class BeizeBoundFunctionValue extends BeizePrimitiveObjectValue
    implements BeizeCallableValue {
  BeizeBoundFunctionValue({
    required this.object,
    required this.function,
  });

  final BeizePrimitiveObjectValue object;
  final BeizeCallableValue function;

  @override
  final String kName = 'Function';

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeCallableValue function = this.function;
    if (function is BeizeFunctionValue) {
      final BeizeNamespace namespace = BeizeNamespace(function.namespace);
      final BeizeVMObjectValue? parentObject = object is BeizeVMObjectValue
          ? (object as BeizeVMObjectValue).parentVMObject
          : null;
      namespace.declare('this', object);
      namespace.declare('super', parentObject ?? BeizeNullValue.value);
      return BeizeFunctionValue(
        constant: function.constant,
        namespace: namespace,
      ).kCall(call);
    }
    final BeizeFunctionCall boundCall = BeizeFunctionCall(
      boundObject: object,
      arguments: call.arguments,
      frame: call.frame,
    );
    return function.kCall(boundCall);
  }

  @override
  BeizeFunctionClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.functionClass;

  @override
  BeizeBoundFunctionValue kClone() =>
      BeizeBoundFunctionValue(object: object, function: function);

  @override
  String kToString() => '<bound function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
