import 'exports.dart';

abstract class OutreStringValueProperties {}

class OutreStringValue extends OutreValue {
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
    (final List<OutreValue> arguments) async => OutreStringValue(
      value +
          (await arguments.first
                  .cast<OutreValue>()
                  .getPropertyOfKey(OutreValueProperties.kToString)
                  .cast<OutreFunctionValue>()
                  .call(<OutreValue>[]))
              .cast<OutreStringValue>()
              .value,
    ),
  );

  late final OutreFunctionValue _asterisk = OutreFunctionValue(
    (final List<OutreValue> arguments) async => OutreStringValue(
      value * arguments.first.cast<OutreNumberValue>().value.toInt(),
    ),
  );
}
