import '../../../vm/exports.dart';
import '../../exports.dart';

typedef BeizeNativeAsyncFunction = Future<BeizeValue> Function(
  BeizeCallableCall call,
);

class BeizeNativeAsyncFunctionValue extends BeizeNativeFunctionValue {
  BeizeNativeAsyncFunctionValue(this.function) : super.internal();

  final BeizeNativeAsyncFunction function;

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) {
    final BeizeValue value = BeizeUnawaitedValue(
      call.arguments,
      (final BeizeCallableCall call) async {
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
      },
    );
    return BeizeInterpreterResult.success(value);
  }

  @override
  BeizeNativeAsyncFunctionValue kClone() =>
      BeizeNativeAsyncFunctionValue(function);

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
