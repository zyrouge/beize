import 'exports.dart';

class BeizeObjectValue extends BeizePrimitiveObjectValue {
  BeizeObjectValue({
    super.keys,
    super.values,
  });

  @override
  final BeizeValueKind kind = BeizeValueKind.object;

  @override
  BeizeObjectValue kClone() => BeizeObjectValue(
        keys: Map<int, BeizeValue>.of(keys),
        values: Map<int, BeizeValue>.of(values),
      );

  @override
  String kToString() {
    final List<String> stringValues = <String>[];
    for (final int x in keys.keys) {
      final String key = keys[x]!.kToString();
      final String value = values[x]!.kToString();
      stringValues.add('$key: $value');
    }
    return '{${stringValues.join(', ')}}';
  }

  @override
  bool get isTruthy => values.isNotEmpty;

  @override
  int get kHashCode => values.hashCode;
}
