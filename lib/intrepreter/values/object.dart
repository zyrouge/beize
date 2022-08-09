import 'values.dart';

class OutreObjectValue extends OutreValue {
  OutreObjectValue(this.properties) : super(OutreValues.objectValue);

  @override
  final Map<OutreValuePropertyKey, OutreValue> properties;
}
