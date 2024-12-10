import '../../vm/exports.dart';
import '../exports.dart';

abstract class BeizeObjectValue extends BeizeValue {
  BeizeObjectValue({
    final Map<String, BeizeValue>? fields,
    final Map<String, dynamic>? internals,
  })  : fields = fields ?? <String, BeizeValue>{},
        internals = internals ?? <String, dynamic>{};

  final Map<String, BeizeValue> fields;
  final Map<String, dynamic> internals;

  bool has(final BeizeValue key) => hasField(key.kToString());
  bool hasField(final String key) => fields.containsKey(key);

  BeizeValue? getOrNull(final BeizeValue key) =>
      getFieldOrNull(key.kToString());

  BeizeValue? getFieldOrNull(final String key) => fields[key];

  BeizeValue get(final BeizeValue key) =>
      getOrNull(key) ?? BeizeNullValue.value;

  BeizeValue getField(final String key) =>
      getFieldOrNull(key) ?? BeizeNullValue.value;

  void set(final BeizeValue key, final BeizeValue value) {
    setField(key.kToString(), value);
  }

  void setField(final String key, final BeizeValue value) {
    fields[key] = value;
  }

  void delete(final BeizeValue key) {
    deleteField(key.kToString());
  }

  void deleteField(final String key) {
    fields.remove(key);
  }

  List<BeizeValue> keys() =>
      fields.keys.map((final String x) => BeizeStringValue(x)).toList();

  List<BeizeValue> values() => fields.values.toList();

  List<MapEntry<BeizeValue, BeizeValue>> entries() {
    final List<MapEntry<BeizeValue, BeizeValue>> entries =
        <MapEntry<BeizeValue, BeizeValue>>[];
    for (final MapEntry<String, BeizeValue> x in fields.entries) {
      final BeizeStringValue key = BeizeStringValue(x.key);
      entries.add(MapEntry<BeizeValue, BeizeValue>(key, x.value));
    }
    return entries;
  }

  void kCopyFrom(final BeizeObjectValue other) {
    fields.addAll(other.fields);
    internals.addAll(other.internals);
  }

  BeizeValue kClone();

  BeizeClassValue? kClassInternal(final BeizeVM vm) => null;

  BeizeClassValue get kClass;
}
