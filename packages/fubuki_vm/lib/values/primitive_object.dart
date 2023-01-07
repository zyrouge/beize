import 'exports.dart';

abstract class FubukiPrimitiveObjectValue extends FubukiValue {
  FubukiPrimitiveObjectValue({
    final Map<int, FubukiValue>? keys,
    final Map<int, FubukiValue>? values,
    final Map<String, dynamic>? internals,
  })  : keys = keys ?? <int, FubukiValue>{},
        values = values ?? <int, FubukiValue>{},
        internals = internals ?? <String, dynamic>{};

  final Map<int, FubukiValue> keys;
  final Map<int, FubukiValue> values;
  final Map<String, dynamic> internals;

  bool has(final FubukiValue key) => keys.containsKey(key.kHashCode);

  FubukiValue? getOrNull(final FubukiValue key) => values[key.kHashCode];

  FubukiValue get(final FubukiValue key) =>
      getOrNull(key) ?? FubukiNullValue.value;

  void set(final FubukiValue key, final FubukiValue value) {
    final int hashCode = key.kHashCode;
    keys[hashCode] = key;
    values[hashCode] = value;
  }

  void delete(final FubukiValue key) {
    final int hashCode = key.kHashCode;
    keys.remove(hashCode);
    values.remove(hashCode);
  }

  List<MapEntry<FubukiValue, FubukiValue>> entries() {
    final List<MapEntry<FubukiValue, FubukiValue>> entries =
        <MapEntry<FubukiValue, FubukiValue>>[];
    for (final int x in keys.keys) {
      entries.add(MapEntry<FubukiValue, FubukiValue>(keys[x]!, values[x]!));
    }
    return entries;
  }

  FubukiValue kClone();
}
