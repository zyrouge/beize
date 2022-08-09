import 'exports.dart';

abstract class OutreBooleanValueProperties {}

class OutreBooleanValue extends OutreValue {
  // ignore: avoid_positional_boolean_parameters
  OutreBooleanValue(this.value) : super(OutreValues.booleanValue);

  final bool value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kUnaryNegate:
        OutreBooleanValue(!value).asOutreFunctionValue(),
    OutreValueProperties.kToString:
        OutreStringValue(value.toString()).asOutreFunctionValue(),
  };
}
