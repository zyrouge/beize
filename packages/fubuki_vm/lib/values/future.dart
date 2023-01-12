import '../vm/exports.dart';
import 'exports.dart';

class FubukiFutureValue extends FubukiPrimitiveObjectValue {
  FubukiFutureValue(
    this.value, {
    this.isHandled = false,
  }) {
    // NOTE: this makes sure that uncaught futures vanish away
    value.catchError(
      (final _) => FubukiNullValue.value,
      test: (final _) => !isHandled,
    );
  }

  final Future<FubukiValue> value;
  bool isHandled;

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'await':
          return FubukiNativeFunctionValue(
            (final FubukiNativeFunctionCall call) async {
              try {
                final FubukiValue result = await value;
                return FubukiInterpreterResult.success(result);
              } catch (err, stackTrace) {
                return FubukiInterpreterResult.fail(
                  FubukiNativeFunctionValue.createValueFromException(
                    call,
                    err.toString(),
                    stackTrace,
                  ),
                );
              }
            },
          );

        case 'then':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue thenFn = call.argumentAt(0);
              value.then((final FubukiValue result) {
                thenFn.callInVM(call.vm, <FubukiValue>[result]);
              });
              return FubukiNullValue.value;
            },
          );

        case 'catchError':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue catchFn = call.argumentAt(0);
              isHandled = true;
              value.catchError((final Object err, final StackTrace stackTrace) {
                final FubukiValue value =
                    FubukiNativeFunctionValue.createValueFromException(
                  call,
                  err.toString(),
                  stackTrace,
                );
                catchFn.callInVM(call.vm, <FubukiValue>[value]);
                return FubukiNullValue.value;
              });
              return FubukiNullValue.value;
            },
          );
      }
    }
    return super.get(key);
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
