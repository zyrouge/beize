import '../../vm/exports.dart';
import '../exports.dart';

typedef BeizeNativeExecuteFunction = BeizeInterpreterResult Function(
  BeizeFunctionCall call,
);

typedef BeizeNativeSyncFunction = BeizeValue Function(
  BeizeFunctionCall call,
);

typedef BeizeNativeAsyncFunction = Future<BeizeValue> Function(
  BeizeFunctionCall call,
);

class BeizeNativeFunctionValue extends BeizePrimitiveObjectValue
    implements BeizeCallableValue {
  BeizeNativeFunctionValue(this.function);

  factory BeizeNativeFunctionValue.sync(
    final BeizeNativeSyncFunction function,
  ) =>
      BeizeNativeFunctionValue(convertSyncFunction(function));

  factory BeizeNativeFunctionValue.async(
    final BeizeNativeAsyncFunction function,
  ) =>
      BeizeNativeFunctionValue(convertAsyncFunction(function));

  final BeizeNativeExecuteFunction function;

  @override
  final BeizeValueKind kind = BeizeValueKind.function;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) => function(call);

  @override
  BeizeNativeFunctionValue kClone() => BeizeNativeFunctionValue(function);

  @override
  String kToString() => '<native function>';

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
