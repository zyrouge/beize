import 'exports.dart';

abstract class OutreStringValueProperties {}

class OutreStringValue extends OutreValueFromProperties {
  OutreStringValue(this.value) : super(OutreValues.stringValue);

  final String value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kAdd: _plus,
    OutreValueProperties.kMultiply: _asterisk,
    OutreValueProperties.kToString:
        OutreFunctionValue.fromOutreValue(OutreStringValue(value)),
  };

  late final OutreFunctionValue _plus = OutreFunctionValue(
    (final OutreFunctionValueCall call) async => OutreStringValue(
      value + call.argAt(0).cast<OutreStringValue>().value,
    ),
  );

  late final OutreFunctionValue _asterisk = OutreFunctionValue(
    (final OutreFunctionValueCall call) async => OutreStringValue(
      value * call.argAt(0).cast<OutreNumberValue>().value.toInt(),
    ),
  );
}
