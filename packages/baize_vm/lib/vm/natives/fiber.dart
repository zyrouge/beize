import 'dart:async';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeFiberNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('wait'),
      BaizeNativeFunctionValue.async(
        (final BaizeNativeFunctionCall call) async {
          final BaizeNumberValue value = call.argumentAt(0);
          await Future<void>.delayed(
            Duration(milliseconds: value.unsafeIntValue),
          );
          return BaizeNullValue.value;
        },
      ),
    );
    value.set(
      BaizeStringValue('runConcurrently'),
      BaizeNativeFunctionValue.async(
        (final BaizeNativeFunctionCall call) async {
          final BaizeListValue fns = call.argumentAt(0);
          final List<BaizeValue> result = await Future.wait(
            fns.elements.map(
              (final BaizeValue x) =>
                  call.frame.callValue(x, <BaizeValue>[]).unwrapUnsafe(),
            ),
          );
          return BaizeListValue(result);
        },
      ),
    );
    namespace.declare('Fiber', value);
  }
}
