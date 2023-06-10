import 'dart:convert';
import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeConvertNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('newBytesList'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeValue value = call.argumentAt(0);
          if (value is BaizeNullValue) {
            return newBytesList(<int>[]);
          }
          final BaizeListValue bytes = value.cast();
          return newBytesList(
            bytes.elements
                .map(
                  (final BaizeValue x) => x.cast<BaizeNumberValue>().intValue,
                )
                .toList(),
          );
        },
      ),
    );
    value.set(
      BaizeStringValue('encodeAscii'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          return newBytesList(ascii.encode(input.value));
        },
      ),
    );
    value.set(
      BaizeStringValue('decodeAscii'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeObjectValue input = call.argumentAt(0);
          return BaizeStringValue(ascii.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      BaizeStringValue('encodeBase64'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeObjectValue input = call.argumentAt(0);
          return BaizeStringValue(base64Encode(toBytes(input)));
        },
      ),
    );
    value.set(
      BaizeStringValue('decodeBase64'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          return newBytesList(base64Decode(input.value));
        },
      ),
    );
    value.set(
      BaizeStringValue('encodeLatin1'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          return newBytesList(latin1.encode(input.value));
        },
      ),
    );
    value.set(
      BaizeStringValue('decodeLatin1'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeObjectValue input = call.argumentAt(0);
          return BaizeStringValue(latin1.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      BaizeStringValue('encodeUtf8'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          return newBytesList(utf8.encode(input.value));
        },
      ),
    );
    value.set(
      BaizeStringValue('decodeUtf8'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeObjectValue input = call.argumentAt(0);
          return BaizeStringValue(utf8.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      BaizeStringValue('encodeJson'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeValue input = call.argumentAt(0);
          return BaizeStringValue(jsonEncode(toJson(input)));
        },
      ),
    );
    value.set(
      BaizeStringValue('decodeJson'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          return fromJson(jsonDecode(input.value));
        },
      ),
    );
    namespace.declare('Convert', value);
  }

  static List<int> toBytes(final BaizeObjectValue bytesList) {
    if (bytesList.internals.containsKey('bytes')) {
      return bytesList.internals['bytes'] as List<int>;
    }
    throw BaizeNativeException('Object is not a bytes list');
  }

  static BaizeValue newBytesList(final List<int> bytes) {
    final BaizeObjectValue bytesList = BaizeObjectValue();
    bytesList.internals['bytes'] = bytes;
    bytesList.set(
      BaizeStringValue('bytes'),
      BaizeNativeFunctionValue.sync(
        (final _) => BaizeListValue(
          bytes.map((final int x) => BaizeNumberValue(x.toDouble())).toList(),
        ),
      ),
    );
    return bytesList;
  }

  static BaizeValue fromJson(final Object? json) {
    if (json is bool) return BaizeBooleanValue(json);
    if (json == null) return BaizeNullValue.value;
    if (json is int) return BaizeNumberValue(json.toDouble());
    if (json is double) return BaizeNumberValue(json);
    if (json is String) return BaizeStringValue(json);
    if (json is List<dynamic>) {
      final BaizeListValue list = BaizeListValue();
      for (final Object? x in json) {
        list.push(fromJson(x));
      }
      return list;
    }
    if (json is Map<dynamic, dynamic>) {
      final BaizeObjectValue obj = BaizeObjectValue();
      for (final MapEntry<Object?, Object?> x in json.entries) {
        final BaizeValue key = fromJson(x.key);
        final BaizeValue value = fromJson(x.value);
        obj.set(key, value);
      }
      return obj;
    }
    return BaizeStringValue(json.toString());
  }

  static Object? toJson(final BaizeValue value) {
    switch (value.kind) {
      case BaizeValueKind.boolean:
        return value.cast<BaizeBooleanValue>().value;

      case BaizeValueKind.list:
        return value.cast<BaizeListValue>().elements.map(toJson).toList();

      case BaizeValueKind.nullValue:
        return null;

      case BaizeValueKind.number:
        return value.cast<BaizeNumberValue>().numValue;

      case BaizeValueKind.object:
        final BaizeObjectValue obj = value.cast();
        final Map<Object?, Object?> json = <Object?, Object?>{};
        for (final MapEntry<BaizeValue, BaizeValue> x in obj.entries()) {
          final Object? key = toJson(x.key);
          final Object? value = toJson(x.value);
          json[key] = value;
        }
        return json;

      case BaizeValueKind.string:
        return value.cast<BaizeStringValue>().value;

      default:
        return value.kToString();
    }
  }
}
