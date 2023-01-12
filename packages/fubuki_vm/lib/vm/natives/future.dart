import 'dart:async';
import '../../values/exports.dart';
import '../namespace.dart';
import '../result.dart';

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
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final FubukiValue value = call.argumentAt(0);
          if (value is FubukiFutureValue) {
            return value.value;
          }
          return value;
        },
      ),
    );
    value.set(
      FubukiStringValue('wait'),
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final FubukiNumberValue value = call.argumentAt(0);
          final Future<FubukiValue> future = Future<FubukiValue>.delayed(
            Duration(milliseconds: value.unsafeIntValue),
            () => FubukiNullValue.value,
          );
          return FubukiFutureValue(future);
        },
      ),
    );
    value.set(
      FubukiStringValue('awaitAll'),
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          final FubukiListValue futures = call.argumentAt(0);
          try {
            final List<FubukiValue> result =
                await Future.wait(castListFutures(futures));
            return FubukiInterpreterResult.success(FubukiListValue(result));
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
      ),
    );
    value.set(
      FubukiStringValue('any'),
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          final FubukiListValue futures = call.argumentAt(0);
          try {
            final FubukiValue result =
                await Future.any(castListFutures(futures));
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
      ),
    );
    namespace.declare('Future', value);
  }

  static FubukiValue newCompleter() {
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

  static Iterable<Future<FubukiValue>> castListFutures(
    final FubukiListValue list,
  ) =>
      list.elements.map(
        (final FubukiValue x) async {
          if (x is FubukiFutureValue) return x.value;
          return x;
        },
      );
}
