import '../../ast/exports.dart';

abstract class OutreGlobalObjectValue {
  static const String name = 'object';

  static OutreObjectValue get value => OutreObjectValue(
        <OutreValuePropertyKey, OutreValue>{
          'keys': OutreFunctionValue(
            (final OutreFunctionValueCall call) async => OutreArrayValue(
              OutreValue.getKeysFromOutreObjectProperties(
                getPropertiesOfOutreValue(call.argAt(0)),
              ),
            ),
          ),
          'values': OutreFunctionValue(
            (final OutreFunctionValueCall call) async => OutreArrayValue(
              OutreValue.getValuesFromOutreObjectProperties(
                getPropertiesOfOutreValue(call.argAt(0)),
              ),
            ),
          ),
          'entries': OutreFunctionValue(
            (final OutreFunctionValueCall call) async => OutreArrayValue(
              OutreValue.getEntriesFromOutreObjectProperties(
                getPropertiesOfOutreValue(call.argAt(0)),
              ),
            ),
          ),
        },
      );

  static Map<OutreValuePropertyKey, OutreValue> getPropertiesOfOutreValue(
    final OutreValue value,
  ) {
    final Map<OutreValuePropertyKey, OutreValue> properties =
        <OutreValuePropertyKey, OutreValue>{};
    properties.addAll(value.defaultProperties);
    if (value is OutreValueFromProperties) {
      properties.addAll(value.properties);
    }
    return properties;
  }
}
