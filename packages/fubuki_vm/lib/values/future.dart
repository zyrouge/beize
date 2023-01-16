import 'exports.dart';

enum FubukiFutureState {
  resolving,
  resolved,
  failed,
}

class FubukiFutureValue extends FubukiPrimitiveObjectValue {
  FubukiFutureValue(this.value);

  final Future<FubukiValue> value;

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'then':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiFunctionValue thenFn = call.argumentAt(0);
              value.then((final FubukiValue result) async {
                await call.frame.callValue(thenFn, <FubukiValue>[result]);
              });
              return FubukiNullValue.value;
            },
          );

        case 'catchError':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiFunctionValue catchFn = call.argumentAt(0);
              value.catchError(
                  (final Object err, final StackTrace stackTrace) async {
                final FubukiValue value =
                    FubukiNativeFunctionValue.createValueFromException(
                  call,
                  err.toString(),
                  stackTrace,
                );
                await call.frame.callValue(catchFn, <FubukiValue>[value]);
                return FubukiNullValue.value;
              });
              return FubukiNullValue.value;
            },
          );
      }
    }
    return super.get(key);
  }

  Future<FubukiValue> resolve() async {
    final FubukiValue result = await value;
    if (result is FubukiFutureValue) return result.resolve();
    return result;
  }

  @override
  final FubukiValueKind kind = FubukiValueKind.future;

  @override
  FubukiFutureValue kClone() => FubukiFutureValue(value);

  @override
  String kToString() => kind.code;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => value.hashCode;
}
