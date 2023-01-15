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
    value.set(
      FubukiStringValue('format'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue template = call.argumentAt(0);
          final FubukiPrimitiveObjectValue env = call.argumentAt(1);
          final bool usePosition = env is FubukiListValue;
          final String result = template.value.replaceAllMapped(
              RegExp(r'(?<!\\){([^}]+)}'), (final Match match) {
            final String key = match[1]!;
            if (usePosition) {
              return env
                  .get(FubukiNumberValue(num.parse(key).toDouble()))
                  .kToString();
            }
            return env.get(FubukiStringValue(key)).kToString();
          });
          return FubukiStringValue(result);
        },
      ),
    );
    namespace.declare('String', value);
  }
}
