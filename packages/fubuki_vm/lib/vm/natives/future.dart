import 'dart:async';
import '../../values/exports.dart';
import '../interpreter.dart';
import '../namespace.dart';

abstract class FubukiFutureNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('new'),
      FubukiNativeFunctionValue.sync((final _) => newCompleter()),
    );
    value.set(
      FubukiStringValue('fromValue'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) =>
            FubukiFutureValue(Future<FubukiValue>.value(call.argumentAt(0))),
      ),
    );
    value.set(
      FubukiStringValue('maybeAwait'),
      FubukiNativeFunctionValue(
        (
          final FubukiNativeFunctionCall call,
          final FubukiInterpreterCompleter completer,
        ) {
          final FubukiValue value = call.argumentAt(0);
          if (value is FubukiFutureValue) {
            return value.bindToCompleter(completer);
          }
          return completer.complete(value);
        },
      ),
    );
    namespace.declare('Future', value);
  }

  static FubukiObjectValue newCompleter() {
    final Completer<FubukiValue> nativeCompleter = Completer<FubukiValue>();
    final FubukiObjectValue completer = FubukiObjectValue();
    completer.set(
      FubukiStringValue('future'),
      FubukiFutureValue(nativeCompleter.future),
    );
    completer.set(
      FubukiStringValue('complete'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          nativeCompleter.complete(call.argumentAt(0));
          return FubukiNullValue.value;
        },
      ),
    );
    completer.set(
      FubukiStringValue('fail'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          nativeCompleter.completeError(call.argumentAt(0));
          return FubukiNullValue.value;
        },
      ),
    );
    return completer;
  }
}
