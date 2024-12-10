import '../../vm/exports.dart';
import '../exports.dart';

typedef BeizeValuePair = ({
  BeizeValue key,
  BeizeValue value,
});

abstract class BeizeObjectValue extends BeizeValue {
  BeizeObjectValue({
    final Map<int, List<BeizeValuePair>>? fields,
    final Map<String, dynamic>? internals,
  })  : fields = fields ?? <int, List<BeizeValuePair>>{},
        internals = internals ?? <String, dynamic>{};

  final Map<int, List<BeizeValuePair>> fields;
  final Map<String, dynamic> internals;

  bool has(final BeizeValue key) {
    final List<BeizeValuePair>? pairs = fields[key.kHashCode];
    if (pairs != null) {
      for (final BeizeValuePair x in pairs) {
        if (x.key.kEquals(key)) {
          return true;
        }
      }
    }
    return false;
  }

  BeizeValue? getOrNull(final BeizeValue key) {
    final List<BeizeValuePair>? pairs = fields[key.kHashCode];
    if (pairs != null) {
      for (final BeizeValuePair x in pairs) {
        if (x.key.kEquals(key)) {
          return x.value;
        }
      }
    }
    return null;
  }

  BeizeValue get(final BeizeValue key) =>
      getOrNull(key) ?? BeizeNullValue.value;

  void set(final BeizeValue key, final BeizeValue value) {
    final List<BeizeValuePair>? pairs = fields[key.kHashCode];
    if (pairs != null) {
      for (int i = 0; i < pairs.length; i++) {
        final BeizeValuePair x = pairs[i];
        if (x.key.kEquals(key)) {
          pairs[i] = (key: x.key, value: value);
          return;
        }
      }
      pairs.add((key: key, value: value));
      return;
    }
    fields[key.kHashCode] = <BeizeValuePair>[(key: key, value: value)];
  }

  void delete(final BeizeValue key) {
    final List<BeizeValuePair>? pairs = fields[key.kHashCode];
    if (pairs == null) {
      return;
    }
    for (int i = 0; i < pairs.length; i++) {
      final BeizeValuePair x = pairs[i];
      if (x.key.kEquals(key)) {
        pairs.removeAt(i);
        break;
      }
    }
  }

  List<BeizeValue> keys() {
    final List<BeizeValue> keys = <BeizeValue>[];
    for (final List<BeizeValuePair> x in fields.values) {
      for (final BeizeValuePair y in x) {
        keys.add(y.key);
      }
    }
    return keys;
  }

  List<BeizeValue> values() {
    final List<BeizeValue> keys = <BeizeValue>[];
    for (final List<BeizeValuePair> x in fields.values) {
      for (final BeizeValuePair y in x) {
        keys.add(y.value);
      }
    }
    return keys;
  }

  List<BeizeValuePair> entries() {
    final List<BeizeValuePair> entries = <BeizeValuePair>[];
    for (final List<BeizeValuePair> x in fields.values) {
      entries.addAll(x);
    }
    return entries;
  }

  BeizeValue kClone();

  BeizeClassValue? kClassInternal(final BeizeVM vm) => null;

  BeizeClassValue get kClass;
}
