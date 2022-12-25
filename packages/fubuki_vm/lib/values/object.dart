import 'exports.dart';

class FubukiObjectValue extends FubukiPrimitiveObjectValue {
  FubukiObjectValue({
    super.keys,
    super.values,
  });

  @override
  final FubukiValueKind kind = FubukiValueKind.object;

  @override
  FubukiObjectValue kClone() => FubukiObjectValue(
        keys: Map<int, FubukiValue>.of(keys),
        values: Map<int, FubukiValue>.of(values),
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
