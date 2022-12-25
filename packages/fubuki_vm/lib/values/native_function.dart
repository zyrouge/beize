import '../vm/exports.dart';
import 'exports.dart';

typedef FubukiNativeFunctionFn = void Function(
  FubukiNativeFunctionCall call,
  FubukiInterpreterCompleter completer,
);

typedef FubukiNativeFunctionSyncFn = FubukiValue Function(
  FubukiNativeFunctionCall call,
);

typedef FubukiNativeFunctionAsyncFn = Future<FubukiValue> Function(
  FubukiNativeFunctionCall call,
);

class FubukiNativeFunctionCall {
  FubukiNativeFunctionCall({
    required this.vm,
    required this.arguments,
  });

  final FubukiVM vm;
  final List<FubukiValue> arguments;

  T argumentAt<T extends FubukiValue>(final int index) =>
      arguments[index].cast<T>();
}

class FubukiNativeFunctionValue extends FubukiPrimitiveObjectValue {
  FubukiNativeFunctionValue(this.nativeFn);

  factory FubukiNativeFunctionValue.sync(
    final FubukiNativeFunctionSyncFn syncFn,
  ) =>
      FubukiNativeFunctionValue(
        (
          final FubukiNativeFunctionCall call,
          final FubukiInterpreterCompleter completer,
        ) {
          try {
            completer.complete(syncFn(call));
          } catch (err) {
            // TODO: better
            completer.fail(FubukiStringValue(err.toString()));
          }
        },
      );

  factory FubukiNativeFunctionValue.async(
    final FubukiNativeFunctionAsyncFn asyncSyncFn,
  ) =>
      FubukiNativeFunctionValue(
        (
          final FubukiNativeFunctionCall call,
          final FubukiInterpreterCompleter completer,
        ) {
          asyncSyncFn(call).then((final FubukiValue value) {
            completer.complete(value);
          }).catchError((final Object err) {
            completer.fail(FubukiStringValue(err.toString()));
          });
        },
      );

  final FubukiNativeFunctionFn nativeFn;

  void call(
    final FubukiNativeFunctionCall call,
    final FubukiInterpreterCompleter completer,
  ) {
    nativeFn(call, completer);
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
}
