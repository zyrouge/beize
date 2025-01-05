import '../vm/exports.dart';
import 'exports.dart';

typedef BeizeObjectValueField = ({
  BeizeValue key,
  BeizeValue value,
});

class BeizeObjectValueFieldsMap {
  const BeizeObjectValueFieldsMap(this.map);

  factory BeizeObjectValueFieldsMap.empty() =>
      // ignore: prefer_const_constructors
      BeizeObjectValueFieldsMap(<int, List<BeizeObjectValueField>>{});

  factory BeizeObjectValueFieldsMap.fromFields(
    final BeizeObjectValueFieldsMap fields,
  ) =>
      BeizeObjectValueFieldsMap(
        Map<int, List<BeizeObjectValueField>>.of(fields.map),
      );

  final Map<int, List<BeizeObjectValueField>> map;

  bool has(final BeizeValue key) {
    final List<BeizeObjectValueField>? found = map[key.kHashCode];
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
    final List<BeizeObjectValueField>? found = map[key.kHashCode];
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

  void set(final BeizeValue key, final BeizeValue value) {
    final int keyHashCode = key.kHashCode;
    final BeizeObjectValueField pair = (key: key, value: value);
    final List<BeizeObjectValueField>? found = map[keyHashCode];
    if (found == null) {
      map[keyHashCode] = <BeizeObjectValueField>[pair];
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
    final List<BeizeObjectValueField>? found = map[key.kHashCode];
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

  BeizeObjectValueFieldsMap clone() =>
      BeizeObjectValueFieldsMap.fromFields(this);

  Iterable<BeizeValue> get keys sync* {
    for (final List<BeizeObjectValueField> x in map.values) {
      for (final BeizeObjectValueField y in x) {
        yield y.key;
      }
    }
  }

  Iterable<BeizeValue> get values sync* {
    for (final List<BeizeObjectValueField> x in map.values) {
      for (final BeizeObjectValueField y in x) {
        yield y.value;
      }
    }
  }

  Iterable<MapEntry<BeizeValue, BeizeValue>> get entries sync* {
    for (final List<BeizeObjectValueField> x in map.values) {
      for (final BeizeObjectValueField y in x) {
        yield MapEntry<BeizeValue, BeizeValue>(y.key, y.value);
      }
    }
  }

  Iterable<BeizeObjectValueField> get fieldEntries sync* {
    for (final List<BeizeObjectValueField> x in map.values) {
      yield* x;
    }
  }
}

abstract class BeizePrimitiveObjectValue extends BeizeValue {
  BeizePrimitiveObjectValue({
    final BeizeObjectValueFieldsMap? fields,
    final Map<String, dynamic>? internals,
  })  : fields = fields ?? BeizeObjectValueFieldsMap.empty(),
        internals = internals ?? <String, dynamic>{};

  final BeizeObjectValueFieldsMap fields;
  final Map<String, dynamic> internals;

  bool has(final BeizeValue key) => fields.has(key);

  BeizeValue? getOrNull(final BeizeValue key) => fields.getOrNull(key);

  BeizeValue get(final BeizeValue key) =>
      getOrNull(key) ?? BeizeNullValue.value;

  BeizeValue getAlongFrame(final BeizeCallFrame frame, final BeizeValue key) =>
      getOrNull(key) ??
      kClass(frame).getInstanceFieldOrNull(this, key) ??
      BeizeNullValue.value;

  BeizeValue? getAlongClassOrNull(
    final BeizePrimitiveClassValue clazz,
    final BeizeValue key,
  ) =>
      getOrNull(key) ?? clazz.getInstanceFieldOrNull(this, key);

  void set(final BeizeValue key, final BeizeValue value) {
    fields.set(key, value);
  }

  void delete(final BeizeValue key) {
    fields.delete(key);
  }

  List<BeizeValue> keys() => fields.keys.toList();

  List<BeizeValue> values() => fields.values.toList();

  List<MapEntry<BeizeValue, BeizeValue>> entries() => fields.entries.toList();

  BeizeListValue kEntries() {
    final BeizeListValue nValue = BeizeListValue();
    for (final BeizeObjectValueField x in fields.fieldEntries) {
      nValue.push(BeizeListValue(<BeizeValue>[x.key, x.value]));
    }
    return nValue;
  }

  BeizePrimitiveClassValue kClass(final BeizeCallFrame frame);

  @override
  bool kEquals(final BeizeValue other) => other == this;

  BeizeValue kClone();
}
