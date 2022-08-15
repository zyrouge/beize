import 'exports.dart';

abstract class OutreArrayValueProperties {
  static const OutreValuePropertyKey kAdd = 'add';
  static const OutreValuePropertyKey kAddAll = 'addAll';
  static const OutreValuePropertyKey kElementAt = 'elementAt';
  static const OutreValuePropertyKey kLength = 'length';
}

class OutreArrayValue extends OutreValueFromProperties {
  OutreArrayValue(this.values) : super(OutreValues.arrayValue);

  final List<OutreValue> values;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreArrayValueProperties.kAdd: _add,
    OutreArrayValueProperties.kAddAll: _addAll,
    OutreArrayValueProperties.kElementAt: _elementAt,
    OutreArrayValueProperties.kLength: _length,
    OutreValueProperties.kIndexAccessGet: _indexAccessGet,
    OutreValueProperties.kIndexAccessSet: _indexAccessSet,
    OutreValueProperties.kToString: OutreFunctionValue(
      (final _) async => OutreStringValue(
        await OutreValueUtils.stringifyMany(values, start: '[', end: ']'),
      ),
    ),
  };

  late final OutreFunctionValue _add = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      values.add(call.argAt(0));
      return OutreNullValue();
    },
  );

  late final OutreFunctionValue _addAll = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      values.addAll(call.argAt(0).cast<OutreArrayValue>().values);
      return OutreNullValue();
    },
  );

  late final OutreFunctionValue _elementAt = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      final OutreNumberValue index = call.argAt(0).cast();
      return getElementAt(index.value.toInt());
    },
  );

  late final OutreFunctionValue _length = OutreFunctionValue(
    (final _) async => OutreNumberValue(values.length.toDouble()),
  );

  late final OutreFunctionValue _indexAccessGet = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      final OutreValue index = call.argAt(0);
      if (index is OutreNumberValue) {
        return getElementAt(index.value.toInt());
      }
      return getPropertyOfKey(OutreValueProperties.kIndexAccessGet)
          .cast<OutreFunctionValue>()
          .call(call);
    },
  );

  late final OutreFunctionValue _indexAccessSet = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      final OutreValue index = call.argAt(0);
      final OutreValue value = call.argAt(1);
      if (index is OutreNumberValue) {
        setElementAt(index.value.toInt(), value);
        return OutreNullValue();
      }
      return getPropertyOfKey(OutreValueProperties.kIndexAccessSet)
          .cast<OutreFunctionValue>()
          .call(call);
    },
  );

  OutreValue getElementAt(final int index) =>
      index < values.length ? values[index] : OutreNullValue();

  void setElementAt(final int index, final OutreValue value) {
    if (index >= values.length) {
      values.addAll(
        List<OutreValue>.filled(index - values.length + 1, OutreNullValue()),
      );
    }
    values[index] = value;
  }
}
