import 'dart:async';
import '../errors/exports.dart';
import '../vm/exports.dart';
import 'exports.dart';

typedef BaizeNativeFunctionFn = Future<BaizeInterpreterResult> Function(
  BaizeNativeFunctionCall call,
);

typedef BaizeNativeFunctionSyncFn = BaizeValue Function(
  BaizeNativeFunctionCall call,
);

typedef BaizeNativeFunctionAsyncFn = Future<BaizeValue> Function(
  BaizeNativeFunctionCall call,
);

class BaizeNativeFunctionCall {
  BaizeNativeFunctionCall({
    required this.frame,
    required this.arguments,
  });

  final BaizeCallFrame frame;
  final List<BaizeValue> arguments;

  T argumentAt<T extends BaizeValue>(final int index) {
    final BaizeValue value =
        index < arguments.length ? arguments[index] : BaizeNullValue.value;
    if (!value.canCast<T>()) {
      throw BaizeRuntimeExpection(
        'Expected argument at $index to be "${BaizeValue.getKindFromType(T).code}", received "${value.kind.code}"',
      );
    }
    return value as T;
  }
}

class BaizeNativeFunctionValue extends BaizePrimitiveObjectValue {
  BaizeNativeFunctionValue(this.nativeFn);

  factory BaizeNativeFunctionValue.sync(
    final BaizeNativeFunctionSyncFn syncFn,
  ) =>
      BaizeNativeFunctionValue(
        (final BaizeNativeFunctionCall call) async {
          try {
            final BaizeValue value = syncFn(call);
            return BaizeInterpreterResult.success(value);
          } catch (err, stackTrace) {
            return createResultFromException(call, err, stackTrace);
          }
        },
      );

  factory BaizeNativeFunctionValue.async(
    final BaizeNativeFunctionAsyncFn asyncFn,
  ) =>
      BaizeNativeFunctionValue(
        (final BaizeNativeFunctionCall call) async {
          try {
            final BaizeValue value = await asyncFn(call);
            return BaizeInterpreterResult.success(value);
          } catch (err, stackTrace) {
            return createResultFromException(call, err, stackTrace);
          }
        },
      );

  final BaizeNativeFunctionFn nativeFn;

  Future<BaizeInterpreterResult> call(
    final BaizeNativeFunctionCall call,
  ) async {
    try {
      return nativeFn(call);
    } catch (err, stackTrace) {
      return createResultFromException(call, err, stackTrace);
    }
  }

  @override
  final BaizeValueKind kind = BaizeValueKind.nativeFunction;

  @override
  BaizeNativeFunctionValue kClone() => BaizeNativeFunctionValue(nativeFn);

  @override
  String kToString() => '<native function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => call.hashCode;

  static BaizeInterpreterResult createResultFromException(
    final BaizeNativeFunctionCall call,
    final Object err,
    final StackTrace stackTrace,
  ) =>
      BaizeInterpreterResult.fail(
        createValueFromException(call, err, stackTrace),
      );

  static BaizeValue createValueFromException(
    final BaizeNativeFunctionCall call,
    final Object err,
    final StackTrace stackTrace,
  ) {
    if (err is BaizeValue) return err;
    return BaizeExceptionNatives.newExceptionNative(
      err.toString(),
      '${call.frame.getStackTrace()}\nDart Stack Trace:\n$stackTrace',
    );
  }
}

extension BaizeValueInterpreterResultUtils on BaizeInterpreterResult {
  BaizeValue unwrapUnsafe() {
    if (isFailure) throw value;
    return value;
  }
}

extension BaizeValueFutureInterpreterResultUtils
    on Future<BaizeInterpreterResult> {
  Future<BaizeValue> unwrapUnsafe() async {
    final BaizeInterpreterResult result = await this;
    return result.unwrapUnsafe();
  }
}
