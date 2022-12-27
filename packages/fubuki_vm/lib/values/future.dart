import '../vm/exports.dart';
import 'exports.dart';

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
              final FubukiValue thenFn = call.argumentAt(0);
              value.then((final FubukiValue result) {
                thenFn.callInVM(call.vm, <FubukiValue>[result]);
              });
              return FubukiNullValue.value;
            },
          );

        case 'catch':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue catchFn = call.argumentAt(1);
              // TODO: fix this
              // ignore: body_might_complete_normally_catch_error
              value.catchError((final Object err) {
                catchFn.callInVM(
                  call.vm,
                  <FubukiValue>[FubukiStringValue(err.toString())],
                );
              });
              return FubukiNullValue.value;
            },
          );

        case 'await':
          return FubukiNativeFunctionValue.async((final _) => value);
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
