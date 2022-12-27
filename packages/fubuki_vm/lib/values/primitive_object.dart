import '../vm/exports.dart';
import 'exports.dart';

abstract class FubukiPrimitiveObjectValue extends FubukiValue {
  FubukiPrimitiveObjectValue({
    final Map<int, FubukiValue>? keys,
    final Map<int, FubukiValue>? values,
  })  : keys = keys ?? <int, FubukiValue>{},
        values = values ?? <int, FubukiValue>{};

  final Map<int, FubukiValue> keys;
  final Map<int, FubukiValue> values;

  bool has(final FubukiValue key) => keys.containsKey(key.kHashCode);

  FubukiValue? getOrNull(final FubukiValue key) =>
      getDefaultProperty(key) ?? values[key.kHashCode];

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

  FubukiValue? getDefaultProperty(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case kCallProperty:
          return FubukiNativeFunctionValue(
            (final FubukiNativeFunctionCall call) =>
                callInVM(call.vm, call.arguments),
          );

        case kStrProperty:
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(kToString()),
          );

        case kEntriesProperty:
          return FubukiNativeFunctionValue.sync(
            (final _) {
              final FubukiListValue result = FubukiListValue();
              for (final int x in keys.keys) {
                result
                    .push(FubukiListValue(<FubukiValue>[keys[x]!, values[x]!]));
              }
              return result;
            },
          );

        case kKeysProperty:
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiListValue(keys.values.toList()),
          );

        case kValuesProperty:
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiListValue(values.values.toList()),
          );

        case kTypeProperty:
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(kind.code),
          );

        case kCloneProperty:
          return FubukiNativeFunctionValue.sync((final _) => kClone());

        case kDeleteProperty:
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue value = call.argumentAt(0);
              delete(value);
              return FubukiNullValue.value;
            },
          );

        default:
      }
    }
    return null;
  }

  FubukiValue kClone();

  static const String kCallProperty = '__call__';
  static const String kStrProperty = '__str__';
  static const String kEntriesProperty = '__entries__';
  static const String kKeysProperty = '__keys__';
  static const String kValuesProperty = '__values__';
  static const String kTypeProperty = '__type__';
  static const String kCloneProperty = '__clone__';
  static const String kDeleteProperty = '__delete__';
}
