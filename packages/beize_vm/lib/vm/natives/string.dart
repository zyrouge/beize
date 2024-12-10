import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeStringNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          return BeizeStringValue(value);
        },
      ),
    );
    value.set(
      BeizeStringValue('fromCodeUnit'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeNumberValue value = call.argumentAt(0);
          return BeizeStringValue(String.fromCharCode(value.intValue));
        },
      ),
    );
    value.set(
      BeizeStringValue('fromCodeUnits'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeListValue value = call.argumentAt(0);
          return BeizeStringValue(
            String.fromCharCodes(
              value.elements.map(
                (final BeizeValue x) => x.cast<BeizeNumberValue>().intValue,
              ),
            ),
          );
        },
      ),
    );
    namespace.declare('String', value);
  }
}
