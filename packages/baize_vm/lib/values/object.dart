import 'exports.dart';

class BaizeObjectValue extends BaizePrimitiveObjectValue {
  BaizeObjectValue({
    super.keys,
    super.values,
  });

  @override
  final BaizeValueKind kind = BaizeValueKind.object;

  @override
  BaizeObjectValue kClone() => BaizeObjectValue(
        keys: Map<int, BaizeValue>.of(keys),
        values: Map<int, BaizeValue>.of(values),
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
