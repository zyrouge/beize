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
    OutreValueProperties.kToString: OutreFunctionValue.fromOutreValue(
      OutreStringValue(
        <String>[
          '[',
          values
              .map(
                (final OutreValue x) => x
                    .getPropertyOfKey(OutreValueProperties.kToString)
                    .cast<OutreFunctionValue>()
                    .call(<OutreValue>[]).cast<OutreStringValue>(),
              )
              .join(','),
          ']',
        ].join(),
      ),
    ),
  };

  late final OutreFunctionValue _add = OutreFunctionValue(
    1,
    (final List<OutreValue> arguments) {
      values.add(arguments.first.cast<OutreValue>());
      return OutreNullValue();
    },
  );

  late final OutreFunctionValue _addAll = OutreFunctionValue(
    1,
    (final List<OutreValue> arguments) {
      values.addAll(arguments.first.cast<OutreArrayValue>().values);
      return OutreNullValue();
    },
  );
}
