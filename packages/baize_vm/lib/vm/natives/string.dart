import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeStringNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('from'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          return BaizeStringValue(value);
        },
      ),
    );
    value.set(
      BaizeStringValue('fromCodeUnit'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeNumberValue value = call.argumentAt(0);
          return BaizeStringValue(String.fromCharCode(value.intValue));
        },
      ),
    );
    value.set(
      BaizeStringValue('fromCodeUnits'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeListValue value = call.argumentAt(0);
          return BaizeStringValue(
            String.fromCharCodes(
              value.elements.map(
                (final BaizeValue x) => x.cast<BaizeNumberValue>().intValue,
              ),
            ),
          );
        },
      ),
    );
    namespace.declare('String', value);
  }
}
