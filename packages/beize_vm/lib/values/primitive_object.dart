import 'exports.dart';

typedef BeizeObjectValueField = ({
  BeizeValue key,
  BeizeValue value,
});

abstract class BeizePrimitiveObjectValue extends BeizeValue {
  BeizePrimitiveObjectValue({
    final Map<int, List<BeizeObjectValueField>>? fields,
    final Map<String, dynamic>? internals,
  })  : fields = fields ?? <int, List<BeizeObjectValueField>>{},
        internals = internals ?? <String, dynamic>{};

  final Map<int, List<BeizeObjectValueField>> fields;
  final Map<String, dynamic> internals;

  bool has(final BeizeValue key) {
    final List<BeizeObjectValueField>? found = fields[key.kHashCode];
    if (found == null) {
      return false;
    }
    for (final BeizeObjectValueField x in found) {
      if (x.key.kEquals(key)) {
        return true;
      }
    }
    return false;
  }

  BeizeValue? getOrNull(final BeizeValue key) {
    final List<BeizeObjectValueField>? found = fields[key.kHashCode];
    if (found == null) {
      return null;
    }
    for (final BeizeObjectValueField x in found) {
      if (x.key.kEquals(key)) {
        return x.value;
      }
    }
    return null;
  }

  BeizeValue get(final BeizeValue key) =>
      getOrNull(key) ?? BeizeNullValue.value;

  void set(final BeizeValue key, final BeizeValue value) {
    final int keyHashCode = key.kHashCode;
    final BeizeObjectValueField pair = (key: key, value: value);
    final List<BeizeObjectValueField>? found = fields[keyHashCode];
    if (found == null) {
      fields[keyHashCode] = <BeizeObjectValueField>[pair];
      return;
    }
    for (int i = 0; i < found.length; i++) {
      final BeizeObjectValueField x = found[i];
      if (x.key.kEquals(key)) {
        found[i] = pair;
        return;
      }
    }
    found.add(pair);
  }

  void delete(final BeizeValue key) {
    final List<BeizeObjectValueField>? found = fields[key.kHashCode];
    if (found == null) {
      return;
    }
    for (int i = 0; i < found.length; i++) {
      final BeizeObjectValueField x = found[i];
      if (x.key.kEquals(key)) {
        found.removeAt(i);
        return;
      }
    }
  }

  List<BeizeValue> keys() {
    final List<BeizeValue> keys = <BeizeValue>[];
    for (final List<BeizeObjectValueField> x in fields.values) {
      for (final BeizeObjectValueField y in x) {
        keys.add(y.key);
      }
    }
    return keys;
  }

  List<BeizeValue> values() {
    final List<BeizeValue> values = <BeizeValue>[];
    for (final List<BeizeObjectValueField> x in fields.values) {
      for (final BeizeObjectValueField y in x) {
        values.add(y.value);
      }
    }
    return values;
  }

  List<MapEntry<BeizeValue, BeizeValue>> entries() {
    final List<MapEntry<BeizeValue, BeizeValue>> entries =
        <MapEntry<BeizeValue, BeizeValue>>[];
    for (final List<BeizeObjectValueField> x in fields.values) {
      for (final BeizeObjectValueField y in x) {
        entries.add(MapEntry<BeizeValue, BeizeValue>(y.key, y.value));
      }
    }
    return entries;
  }

  BeizeValue kClone();
}
