import 'exports.dart';

abstract class OutreNullValueProperties {}

class OutreNullValue extends OutreValue {
  OutreNullValue._() : super(OutreValues.nullValue);

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kToString:
        OutreStringValue('null').asOutreFunctionValue(),
  };

  static final OutreNullValue value = OutreNullValue._();
}
