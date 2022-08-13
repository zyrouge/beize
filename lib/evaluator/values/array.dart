import 'exports.dart';

abstract class OutreArrayValueProperties {
  static const OutreValuePropertyKey kAddAll = 'addAll';
}

class OutreArrayValue extends OutreValue {
  OutreArrayValue(this.values) : super(OutreValues.arrayValue);

  final List<OutreValue> values;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kAdd: _add,
    OutreArrayValueProperties.kAddAll: _addAll,
    OutreValueProperties.kToString: OutreFunctionValue(
      (final _) async => OutreStringValue(
        await OutreValueUtils.stringifyMany(values, start: '[', end: ']'),
      ),
    ),
  };

  late final OutreFunctionValue _add = OutreFunctionValue(
    (final List<OutreValue> arguments) async {
      values.add(arguments.first.cast<OutreValue>());
      return OutreNullValue();
    },
  );

  late final OutreFunctionValue _addAll = OutreFunctionValue(
    (final List<OutreValue> arguments) async {
      values.addAll(arguments.first.cast<OutreArrayValue>().values);
      return OutreNullValue();
    },
  );
}
