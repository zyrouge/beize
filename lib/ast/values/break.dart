import 'exports.dart';

class OutreBreakValue extends OutreValueFromProperties {
  OutreBreakValue() : super(OutreValues.internalBreakValue);

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{};
}
