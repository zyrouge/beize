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
      namespace.declare('this', object);
      return BeizeFunctionValue(
        constant: function.constant,
        namespace: namespace,
      ).kCall(call);
    }
    final BeizeFunctionCall boundCall = BeizeFunctionCall(
      arguments: <BeizeValue>[object, ...call.arguments],
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

  static BeizeNativeExecuteFunction convertSyncFunction(
    final BeizeNativeSyncFunction function,
  ) =>
      (final BeizeFunctionCall call) {
        try {
          final BeizeValue value = function(call);
          return BeizeInterpreterResult.success(value);
        } catch (err, stackTrace) {
          return BeizeFunctionValueUtils.handleException(
            call.frame,
            err,
            stackTrace,
          );
        }
      };

  static BeizeNativeExecuteFunction convertAsyncFunction(
    final BeizeNativeAsyncFunction function,
  ) =>
      (final BeizeFunctionCall call) {
        final BeizeValue value = BeizeUnawaitedValue(
          call.arguments,
          wrapAsyncFunction(function),
        );
        return BeizeInterpreterResult.success(value);
      };

  static BeizeUnawaitedFunction wrapAsyncFunction(
    final BeizeNativeAsyncFunction function,
  ) =>
      (final BeizeFunctionCall call) async {
        try {
          final BeizeValue value = await function(call);
          return BeizeInterpreterResult.success(value);
        } catch (err, stackTrace) {
          return BeizeFunctionValueUtils.handleException(
            call.frame,
            err,
            stackTrace,
          );
        }
      };
}
