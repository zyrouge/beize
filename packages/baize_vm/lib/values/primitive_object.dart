import 'exports.dart';

abstract class BaizePrimitiveObjectValue extends BaizeValue {
  BaizePrimitiveObjectValue({
    final Map<int, BaizeValue>? keys,
    final Map<int, BaizeValue>? values,
    final Map<String, dynamic>? internals,
  })  : keys = keys ?? <int, BaizeValue>{},
        values = values ?? <int, BaizeValue>{},
        internals = internals ?? <String, dynamic>{};

  final Map<int, BaizeValue> keys;
  final Map<int, BaizeValue> values;
  final Map<String, dynamic> internals;

  bool has(final BaizeValue key) => keys.containsKey(key.kHashCode);

  BaizeValue? getOrNull(final BaizeValue key) => values[key.kHashCode];

  BaizeValue get(final BaizeValue key) =>
      getOrNull(key) ?? BaizeNullValue.value;

  void set(final BaizeValue key, final BaizeValue value) {
    final int hashCode = key.kHashCode;
    keys[hashCode] = key;
    values[hashCode] = value;
  }

  void delete(final BaizeValue key) {
    final int hashCode = key.kHashCode;
    keys.remove(hashCode);
    values.remove(hashCode);
  }

  List<MapEntry<BaizeValue, BaizeValue>> entries() {
    final List<MapEntry<BaizeValue, BaizeValue>> entries =
        <MapEntry<BaizeValue, BaizeValue>>[];
    for (final int x in keys.keys) {
      entries.add(MapEntry<BaizeValue, BaizeValue>(keys[x]!, values[x]!));
    }
    return entries;
  }

  BaizeValue kClone();
}
