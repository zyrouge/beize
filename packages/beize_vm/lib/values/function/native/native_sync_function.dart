import '../../../vm/exports.dart';
import '../../exports.dart';

typedef BeizeNativeSyncFunction = BeizeValue Function(
  BeizeCallableCall call,
);

class BeizeNativeSyncFunctionValue extends BeizeNativeFunctionValue {
  BeizeNativeSyncFunctionValue(this.function) : super.internal();

  final BeizeNativeSyncFunction function;

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) {
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
  }

  @override
  BeizeNativeSyncFunctionValue kClone() =>
      BeizeNativeSyncFunctionValue(function)..kCopyFrom(this);

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
