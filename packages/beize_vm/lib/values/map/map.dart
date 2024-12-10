import '../../vm/exports.dart';
import '../exports.dart';

typedef _ValuePair = ({
  BeizeValue key,
  BeizeValue value,
});

class BeizeMapValue extends BeizeNativeObjectValue {
  BeizeMapValue([final Map<int, List<_ValuePair>>? mapFields])
      : mapFields = mapFields ?? <int, List<_ValuePair>>{};

  final Map<int, List<_ValuePair>> mapFields;

  @override
  final BeizeValueKind kind = BeizeValueKind.object;

  @override
  bool has(final BeizeValue key) {
    final List<_ValuePair>? found = mapFields[key.kHashCode];
    if (found != null) {
      for (final _ValuePair x in found) {
        if (x.key.kEquals(key)) {
          return true;
        }
      }
    }
    return super.has(key);
  }

  @override
  BeizeValue? getOrNull(final BeizeValue key) {
    final List<_ValuePair>? found = mapFields[key.kHashCode];
    if (found != null) {
      for (final _ValuePair x in found) {
        if (x.key.kEquals(key)) {
          return x.value;
        }
      }
    }
    return super.getOrNull(key);
  }

  @override
  BeizeValue get(final BeizeValue key) =>
      getOrNull(key) ?? BeizeNullValue.value;

  @override
  void set(final BeizeValue key, final BeizeValue value) {
    final int keyHashCode = key.kHashCode;
    final _ValuePair pair = (key: key, value: value);
    final List<_ValuePair>? found = mapFields[keyHashCode];
    if (found == null) {
      mapFields[keyHashCode] = <_ValuePair>[pair];
      return;
    }
    for (int i = 0; i < found.length; i++) {
      final _ValuePair x = found[i];
      if (x.key.kEquals(key)) {
        found[i] = pair;
        return;
      }
    }
    found.add(pair);
  }

  @override
  void delete(final BeizeValue key) {
    final List<_ValuePair>? found = mapFields[key.kHashCode];
    if (found != null) {
      for (int i = 0; i < found.length; i++) {
        final _ValuePair x = found[i];
        if (x.key.kEquals(key)) {
          found.removeAt(i);
          return;
        }
      }
    }
    super.delete(key);
  }

  @override
  List<BeizeValue> keys() {
    final List<BeizeValue> keys = <BeizeValue>[];
    for (final List<_ValuePair> x in mapFields.values) {
      for (final _ValuePair y in x) {
        keys.add(y.key);
      }
    }
    keys.addAll(super.keys());
    return keys;
  }

  @override
  List<BeizeValue> values() {
    final List<BeizeValue> values = <BeizeValue>[];
    for (final List<_ValuePair> x in mapFields.values) {
      for (final _ValuePair y in x) {
        values.add(y.value);
      }
    }
    values.addAll(super.values());
    return values;
  }

  @override
  List<MapEntry<BeizeValue, BeizeValue>> entries() {
    final List<MapEntry<BeizeValue, BeizeValue>> entries =
        <MapEntry<BeizeValue, BeizeValue>>[];
    for (final List<_ValuePair> x in mapFields.values) {
      for (final _ValuePair y in x) {
        entries.add(MapEntry<BeizeValue, BeizeValue>(y.key, y.value));
      }
    }
    entries.addAll(super.entries());
    return entries;
  }

  @override
  BeizeMapValue kClone() =>
      BeizeMapValue(Map<int, List<_ValuePair>>.of(mapFields))..kCopyFrom(this);

  @override
  String kToString() {
    final StringBuffer buffer = StringBuffer('{');
    bool hasKeys = false;
    for (final List<_ValuePair> x in mapFields.values) {
      for (final _ValuePair y in x) {
        if (hasKeys) {
          buffer.write(', ');
        }
        hasKeys = true;
        final String key = y.key.kToString();
        final String value = y.value.kToString();
        buffer.write('$key: $value');
      }
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.mapClass;

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => fields.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
