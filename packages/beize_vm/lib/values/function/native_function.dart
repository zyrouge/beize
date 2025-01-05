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

typedef BeizeNativeBoundSyncFunction<T extends BeizePrimitiveObjectValue>
    = BeizeValue Function(
  T object,
  BeizeFunctionCall call,
);

typedef BeizeNativeBoundAsyncFunction<T extends BeizePrimitiveObjectValue>
    = Future<BeizeValue> Function(
  T object,
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
  final String kName = 'Function';

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) => function(call);

  @override
  BeizeFunctionClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.functionClass;

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
    // ignore: prefer_expression_function_bodies
  ) {
    return (final BeizeFunctionCall call) {
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
  }

  static BeizeNativeExecuteFunction convertAsyncFunction(
    final BeizeNativeAsyncFunction function,
    // ignore: prefer_expression_function_bodies
  ) {
    return (final BeizeFunctionCall call) {
      final BeizeValue value = BeizeUnawaitedValue(
        call.arguments,
        wrapAsyncFunction(function),
      );
      return BeizeInterpreterResult.success(value);
    };
  }

  static BeizeUnawaitedFunction wrapAsyncFunction(
    final BeizeNativeAsyncFunction function,
    // ignore: prefer_expression_function_bodies
  ) {
    return (final BeizeFunctionCall call) async {
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

  static BeizeNativeExecuteFunction
      convertBoundSyncFunction<T extends BeizePrimitiveObjectValue>(
    final BeizeNativeBoundSyncFunction<T> function,
    // ignore: prefer_expression_function_bodies
  ) {
    return (final BeizeFunctionCall call) {
      try {
        final T object = call.argumentAt(0);
        final BeizeValue value = function(object, call);
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

  static BeizeNativeFunctionValue
      boundSync<T extends BeizePrimitiveObjectValue>(
    final BeizeNativeBoundSyncFunction<T> function,
  ) =>
          BeizeNativeFunctionValue(convertBoundSyncFunction(function));

  static BeizeNativeFunctionValue
      boundAsync<T extends BeizePrimitiveObjectValue>(
    final BeizeNativeBoundAsyncFunction<T> function,
  ) =>
          BeizeNativeFunctionValue(convertBoundAsyncFunction(function));

  static BeizeNativeExecuteFunction
      convertBoundAsyncFunction<T extends BeizePrimitiveObjectValue>(
    final BeizeNativeBoundAsyncFunction<T> function,
    // ignore: prefer_expression_function_bodies
  ) {
    return (final BeizeFunctionCall call) {
      final BeizeValue value = BeizeUnawaitedValue(
        call.arguments,
        wrapBoundAsyncFunction(function),
      );
      return BeizeInterpreterResult.success(value);
    };
  }

  static BeizeUnawaitedFunction
      wrapBoundAsyncFunction<T extends BeizePrimitiveObjectValue>(
    final BeizeNativeBoundAsyncFunction<T> function,
    // ignore: prefer_expression_function_bodies
  ) {
    return (final BeizeFunctionCall call) async {
      try {
        final T object = call.argumentAt(0);
        final BeizeValue value = await function(object, call);
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
}
