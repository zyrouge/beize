import 'exports.dart';

abstract class BeizePrimitiveObjectValue extends BeizeValue {
  BeizePrimitiveObjectValue({
    final Map<int, BeizeValue>? keys,
    final Map<int, BeizeValue>? values,
    final Map<String, dynamic>? internals,
  })  : keys = keys ?? <int, BeizeValue>{},
        values = values ?? <int, BeizeValue>{},
        internals = internals ?? <String, dynamic>{};

  final Map<int, BeizeValue> keys;
  final Map<int, BeizeValue> values;
  final Map<String, dynamic> internals;

  bool has(final BeizeValue key) => keys.containsKey(key.kHashCode);

  BeizeValue? getOrNull(final BeizeValue key) => values[key.kHashCode];

  BeizeValue get(final BeizeValue key) =>
      getOrNull(key) ?? BeizeNullValue.value;

  void set(final BeizeValue key, final BeizeValue value) {
    final int hashCode = key.kHashCode;
    keys[hashCode] = key;
    values[hashCode] = value;
  }

  void delete(final BeizeValue key) {
    final int hashCode = key.kHashCode;
    keys.remove(hashCode);
    values.remove(hashCode);
  }

  List<MapEntry<BeizeValue, BeizeValue>> entries() {
    final List<MapEntry<BeizeValue, BeizeValue>> entries =
        <MapEntry<BeizeValue, BeizeValue>>[];
    for (final int x in keys.keys) {
      entries.add(MapEntry<BeizeValue, BeizeValue>(keys[x]!, values[x]!));
    }
    return entries;
  }

  BeizeValue kClone();
}
