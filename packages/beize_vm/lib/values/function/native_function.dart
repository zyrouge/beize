import '../../vm/exports.dart';
import '../exports.dart';

typedef BeizeNativeExecuteFunction = BeizeInterpreterResult Function(
  BeizeNativeFunctionCall call,
);

typedef BeizeNativeSyncFunction = BeizeValue Function(
  BeizeNativeFunctionCall call,
);

typedef BeizeNativeAsyncFunction = Future<BeizeValue> Function(
  BeizeNativeFunctionCall call,
);

class BeizeNativeFunctionValue extends BeizePrimitiveObjectValue {
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

  BeizeInterpreterResult execute(final BeizeNativeFunctionCall call) {
    try {
      final BeizeInterpreterResult result = function(call);
      return result;
    } catch (err, stackTrace) {
      return BeizeFunctionValueUtils.handleException(
        call.frame,
        err,
        stackTrace,
      );
    }
  }

  @override
  final BeizeValueKind kind = BeizeValueKind.nativeFunction;

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
      (final BeizeNativeFunctionCall call) {
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
      (final BeizeNativeFunctionCall call) {
        final BeizeValue value = BeizeUnawaitedValue(
          call.arguments,
          wrapAsyncFunction(function),
        );
        return BeizeInterpreterResult.success(value);
      };

  static BeizeUnawaitedFunction wrapAsyncFunction(
    final BeizeNativeAsyncFunction function,
  ) =>
      (final BeizeNativeFunctionCall call) async {
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
