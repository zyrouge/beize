import 'exports.dart';

abstract class OutreNullValueProperties {}

class OutreNullValue extends OutreValueFromProperties {
  factory OutreNullValue() => _value;

  OutreNullValue._() : super(OutreValues.nullValue);

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kToString:
        OutreStringValue('null').asOutreFunctionValue(),
  };

  static final OutreNullValue _value = OutreNullValue._();
}
