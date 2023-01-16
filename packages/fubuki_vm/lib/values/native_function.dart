import 'dart:async';
import '../errors/exports.dart';
import '../vm/exports.dart';
import 'exports.dart';

typedef FubukiNativeFunctionFn = Future<FubukiInterpreterResult> Function(
  FubukiNativeFunctionCall call,
);

typedef FubukiNativeFunctionSyncFn = FubukiValue Function(
  FubukiNativeFunctionCall call,
);

typedef FubukiNativeFunctionAsyncFn = Future<FubukiValue> Function(
  FubukiNativeFunctionCall call,
);

class FubukiNativeFunctionCall {
  FubukiNativeFunctionCall({
    required this.frame,
    required this.arguments,
  });

  final FubukiCallFrame frame;
  final List<FubukiValue> arguments;

  T argumentAt<T extends FubukiValue>(final int index) {
    final FubukiValue value =
        index < arguments.length ? arguments[index] : FubukiNullValue.value;
    if (!value.canCast<T>()) {
      throw FubukiRuntimeExpection(
        'Expected argument at $index to be "${FubukiValue.getKindFromType(T).code}", received "${value.kind.code}"',
      );
    }
    return value as T;
  }
}

class FubukiNativeFunctionValue extends FubukiPrimitiveObjectValue {
  FubukiNativeFunctionValue(this.nativeFn);

  factory FubukiNativeFunctionValue.sync(
    final FubukiNativeFunctionSyncFn syncFn,
  ) =>
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          try {
            final FubukiValue value = syncFn(call);
            return FubukiInterpreterResult.success(value);
          } catch (err, stackTrace) {
            return createResultFromException(call, err, stackTrace);
          }
        },
      );

  factory FubukiNativeFunctionValue.async(
    final FubukiNativeFunctionAsyncFn asyncFn,
  ) =>
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          try {
            final FubukiValue value = await asyncFn(call);
            return FubukiInterpreterResult.success(value);
          } catch (err, stackTrace) {
            return createResultFromException(call, err, stackTrace);
          }
        },
      );

  factory FubukiNativeFunctionValue.asyncReturn(
    final FubukiNativeFunctionAsyncFn asyncFn,
  ) =>
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          try {
            final Completer<FubukiValue> completer = Completer<FubukiValue>();
            asyncFn(call).then(
              completer.complete,
              onError: completer.completeError,
            );
            return FubukiInterpreterResult.success(
              FubukiFutureValue(completer.future),
            );
          } catch (err, stackTrace) {
            return createResultFromException(call, err, stackTrace);
          }
        },
      );

  final FubukiNativeFunctionFn nativeFn;

  Future<FubukiInterpreterResult> call(
    final FubukiNativeFunctionCall call,
  ) async {
    try {
      return nativeFn(call);
    } catch (err, stackTrace) {
      return createResultFromException(call, err, stackTrace);
    }
  }

  @override
  final FubukiValueKind kind = FubukiValueKind.nativeFunction;

  @override
  FubukiNativeFunctionValue kClone() => FubukiNativeFunctionValue(nativeFn);

  @override
  String kToString() => '<native function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => call.hashCode;

  static FubukiInterpreterResult createResultFromException(
    final FubukiNativeFunctionCall call,
    final Object err,
    final StackTrace stackTrace,
  ) =>
      FubukiInterpreterResult.fail(
        createValueFromException(call, err, stackTrace),
      );

  static FubukiValue createValueFromException(
    final FubukiNativeFunctionCall call,
    final Object err,
    final StackTrace stackTrace,
  ) {
    if (err is FubukiValue) return err;
    return FubukiExceptionNatives.newExceptionNative(
      err.toString(),
      '${call.frame.getStackTrace()}\nDart Stack Trace:\n$stackTrace',
    );
  }
}

extension FubukiValueInterpreterResultUtils on FubukiInterpreterResult {
  FubukiValue unwrapUnsafe() {
    if (isFailure) {
      throw FubukiRuntimeExpection.unwrapFailed(value.kToString());
    }
    return value;
  }
}

extension FubukiValueFutureInterpreterResultUtils
    on Future<FubukiInterpreterResult> {
  Future<FubukiValue> unwrapUnsafe() async {
    final FubukiInterpreterResult result = await this;
    return result.unwrapUnsafe();
  }
}
