import 'value.dart';

class OutreObjectValue extends OutreValueFromProperties {
  OutreObjectValue(this.properties) : super(OutreValues.objectValue);

  @override
  final Map<OutreValuePropertyKey, OutreValue> properties;
}
