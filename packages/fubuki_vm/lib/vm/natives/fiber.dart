import 'dart:async';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiFiberNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('wait'),
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final FubukiNumberValue value = call.argumentAt(0);
          await Future<void>.delayed(
            Duration(milliseconds: value.unsafeIntValue),
          );
          return FubukiNullValue.value;
        },
      ),
    );
    value.set(
      FubukiStringValue('runConcurrently'),
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final FubukiListValue fns = call.argumentAt(0);
          final List<FubukiValue> result = await Future.wait(
            fns.elements.map(
              (final FubukiValue x) =>
                  call.frame.callValue(x, <FubukiValue>[]).unwrapUnsafe(),
            ),
          );
          return FubukiListValue(result);
        },
      ),
    );
    namespace.declare('Future', value);
  }
}
