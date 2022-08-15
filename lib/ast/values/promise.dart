import 'exports.dart';

abstract class OutrePromiseValueProperties {}

class OutrePromiseValue extends OutreValueFromProperties {
  OutrePromiseValue(this.value) : super(OutreValues.promiseValue);

  final Future<OutreValue> value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kAwait: OutreFunctionValue((final _) async => value),
  };

  Future<OutreValue> resolve() async => value;
}
