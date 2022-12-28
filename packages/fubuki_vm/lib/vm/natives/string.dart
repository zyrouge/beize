import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiStringNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          return FubukiStringValue(value);
        },
      ),
    );
    value.set(
      FubukiStringValue('fromCodeUnit'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiNumberValue value = call.argumentAt(0);
          return FubukiStringValue(String.fromCharCode(value.intValue));
        },
      ),
    );
    value.set(
      FubukiStringValue('fromCodeUnits'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiListValue value = call.argumentAt(0);
          return FubukiStringValue(
            String.fromCharCodes(
              value.elements.map(
                (final FubukiValue x) => x.cast<FubukiNumberValue>().intValue,
              ),
            ),
          );
        },
      ),
    );
    namespace.declare('String', value);
  }
}
