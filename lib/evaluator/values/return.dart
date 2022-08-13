import 'exports.dart';

class OutreReturnValue extends OutreValue {
  OutreReturnValue(this.value) : super(OutreValues.internalReturnValue);

  final OutreValue value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{};
}
