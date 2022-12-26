import '../vm/exports.dart';
import 'exports.dart';

class FubukiFutureValue extends FubukiPrimitiveObjectValue {
  FubukiFutureValue(this.value);

  final Future<FubukiValue> value;

  void bindToCompleter(
    final FubukiInterpreterCompleter completer, {
    final bool onComplete = true,
    final bool onFail = true,
  }) {
    value.then((final FubukiValue value) {
      completer.complete(value);
    }).catchError((final Object err) {
      // TODO: fix this
      completer.fail(FubukiStringValue(err.toString()));
    });
  }

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'then':
          return FubukiNativeFunctionValue(
            (
              final FubukiNativeFunctionCall call,
              final FubukiInterpreterCompleter completer,
            ) {
              final FubukiValue thenFn = call.argumentAt(0);
              value.then((final FubukiValue result) {
                thenFn.callInVM(
                  call.vm,
                  <FubukiValue>[result],
                  FubukiInterpreterCompleter.empty(),
                );
              });
              completer.complete(FubukiNullValue.value);
            },
          );

        case 'catch':
          return FubukiNativeFunctionValue(
            (
              final FubukiNativeFunctionCall call,
              final FubukiInterpreterCompleter completer,
            ) {
              final FubukiValue catchFn = call.argumentAt(1);
              // ignore: body_might_complete_normally_catch_error
              value.catchError((final Object err) {
                // TODO: fix this
                catchFn.callInVM(
                  call.vm,
                  <FubukiValue>[FubukiStringValue(err.toString())],
                  FubukiInterpreterCompleter.empty(),
                );
              });
              completer.complete(FubukiNullValue.value);
            },
          );

        case 'await':
          return FubukiNativeFunctionValue(
            (
              final FubukiNativeFunctionCall call,
              final FubukiInterpreterCompleter completer,
            ) {
              bindToCompleter(completer);
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
