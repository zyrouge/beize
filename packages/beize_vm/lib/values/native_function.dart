import 'dart:async';
import '../errors/exports.dart';
import '../vm/exports.dart';
import 'exports.dart';

typedef BeizeNativeFunctionFn = Future<BeizeInterpreterResult> Function(
  BeizeNativeFunctionCall call,
);

typedef BeizeNativeFunctionSyncFn = BeizeValue Function(
  BeizeNativeFunctionCall call,
);

typedef BeizeNativeFunctionAsyncFn = Future<BeizeValue> Function(
  BeizeNativeFunctionCall call,
);

class BeizeNativeFunctionCall {
  BeizeNativeFunctionCall({
    required this.frame,
    required this.arguments,
  });

  final BeizeCallFrame frame;
  final List<BeizeValue> arguments;

  T argumentAt<T extends BeizeValue>(final int index) {
    final BeizeValue value =
        index < arguments.length ? arguments[index] : BeizeNullValue.value;
    if (!value.canCast<T>()) {
      throw BeizeRuntimeExpection(
        'Expected argument at $index to be "${BeizeValue.getKindFromType(T).code}", received "${value.kind.code}"',
      );
    }
    return value as T;
  }
}

class BeizeNativeFunctionValue extends BeizePrimitiveObjectValue {
  BeizeNativeFunctionValue(this.nativeFn);

  factory BeizeNativeFunctionValue.sync(
    final BeizeNativeFunctionSyncFn syncFn,
  ) =>
      BeizeNativeFunctionValue(
        (final BeizeNativeFunctionCall call) async {
          try {
            final BeizeValue value = syncFn(call);
            return BeizeInterpreterResult.success(value);
          } catch (err, stackTrace) {
            return handleException(call, err, stackTrace);
          }
        },
      );

  factory BeizeNativeFunctionValue.async(
    final BeizeNativeFunctionAsyncFn asyncFn,
  ) =>
      BeizeNativeFunctionValue(
        (final BeizeNativeFunctionCall call) async {
          try {
            final BeizeValue value = await asyncFn(call);
            return BeizeInterpreterResult.success(value);
          } catch (err, stackTrace) {
            return handleException(call, err, stackTrace);
          }
        },
      );

  final BeizeNativeFunctionFn nativeFn;

  Future<BeizeInterpreterResult> call(
    final BeizeNativeFunctionCall call,
  ) async {
    try {
      return nativeFn(call);
    } catch (err, stackTrace) {
      return handleException(call, err, stackTrace);
    }
  }

  @override
  final BeizeValueKind kind = BeizeValueKind.nativeFunction;

  @override
  BeizeNativeFunctionValue kClone() => BeizeNativeFunctionValue(nativeFn);

  @override
  String kToString() => '<native function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => call.hashCode;

  static BeizeInterpreterResult handleException(
    final BeizeNativeFunctionCall call,
    final Object err,
    final StackTrace stackTrace,
  ) =>
      BeizeInterpreterResult.fail(createExceptionValue(call, err, stackTrace));

  static BeizeExceptionValue createExceptionValue(
    final BeizeNativeFunctionCall call,
    final Object err,
    final StackTrace stackTrace,
  ) {
    if (err is BeizeExceptionValue) return err;
    return BeizeExceptionValue(
      err is BeizeNativeException ? err.message : err.toString(),
      call.frame.getStackTrace(),
      stackTrace.toString(),
    );
  }
}

extension BeizeValueInterpreterResultUtils on BeizeInterpreterResult {
  BeizeValue unwrapUnsafe() {
    if (isFailure) throw value;
    return value;
  }
}

extension BeizeValueFutureInterpreterResultUtils
    on Future<BeizeInterpreterResult> {
  Future<BeizeValue> unwrapUnsafe() async {
    final BeizeInterpreterResult result = await this;
    return result.unwrapUnsafe();
  }
}
