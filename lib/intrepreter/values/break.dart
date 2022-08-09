import 'exports.dart';

class OutreBreakValue extends OutreValue {
  OutreBreakValue() : super(OutreValues.internalBreakValue);

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{};
}
