import 'dart:convert';
import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiConvertNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('newBytesList'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiValue value = call.argumentAt(0);
          if (value is FubukiNullValue) {
            return newBytesList(<int>[]);
          }
          final FubukiListValue bytes = value.cast();
          return newBytesList(
            bytes.elements
                .map(
                  (final FubukiValue x) => x.cast<FubukiNumberValue>().intValue,
                )
                .toList(),
          );
        },
      ),
    );
    value.set(
      FubukiStringValue('encodeAscii'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          return newBytesList(ascii.encode(input.value));
        },
      ),
    );
    value.set(
      FubukiStringValue('decodeAscii'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiObjectValue input = call.argumentAt(0);
          return FubukiStringValue(ascii.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      FubukiStringValue('encodeBase64'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiObjectValue input = call.argumentAt(0);
          return FubukiStringValue(base64Encode(toBytes(input)));
        },
      ),
    );
    value.set(
      FubukiStringValue('decodeBase64'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          return newBytesList(base64Decode(input.value));
        },
      ),
    );
    value.set(
      FubukiStringValue('encodeLatin1'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          return newBytesList(latin1.encode(input.value));
        },
      ),
    );
    value.set(
      FubukiStringValue('decodeLatin1'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiObjectValue input = call.argumentAt(0);
          return FubukiStringValue(latin1.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      FubukiStringValue('encodeUtf8'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          return newBytesList(utf8.encode(input.value));
        },
      ),
    );
    value.set(
      FubukiStringValue('decodeUtf8'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiObjectValue input = call.argumentAt(0);
          return FubukiStringValue(utf8.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      FubukiStringValue('encodeJson'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiValue input = call.argumentAt(0);
          return FubukiStringValue(jsonEncode(toJson(input)));
        },
      ),
    );
    value.set(
      FubukiStringValue('decodeJson'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          return fromJson(jsonDecode(input.value));
        },
      ),
    );
    namespace.declare('Convert', value);
  }

  static List<int> toBytes(final FubukiObjectValue bytesList) {
    if (bytesList.internals.containsKey('bytes')) {
      return bytesList.internals['bytes'] as List<int>;
    }
    throw FubukiNativeException('Object is not a bytes list');
  }

  static FubukiValue newBytesList(final List<int> bytes) {
    final FubukiObjectValue bytesList = FubukiObjectValue();
    bytesList.internals['bytes'] = bytes;
    bytesList.set(
      FubukiStringValue('bytes'),
      FubukiNativeFunctionValue.sync(
        (final _) => FubukiListValue(
          bytes.map((final int x) => FubukiNumberValue(x.toDouble())).toList(),
        ),
      ),
    );
    return bytesList;
  }

  static FubukiValue fromJson(final Object? json) {
    if (json is bool) return FubukiBooleanValue(json);
    if (json == null) return FubukiNullValue.value;
    if (json is int) return FubukiNumberValue(json.toDouble());
    if (json is double) return FubukiNumberValue(json);
    if (json is String) return FubukiStringValue(json);
    if (json is List<dynamic>) {
      final FubukiListValue list = FubukiListValue();
      for (final Object? x in json) {
        list.push(fromJson(x));
      }
    }
    if (json is Map<dynamic, dynamic>) {
      final FubukiObjectValue obj = FubukiObjectValue();
      for (final MapEntry<Object?, Object?> x in json.entries) {
        final FubukiValue key = fromJson(x.key);
        final FubukiValue value = fromJson(x.value);
        obj.set(key, value);
      }
      return obj;
    }
    return FubukiStringValue(json.toString());
  }

  static Object? toJson(final FubukiValue value) {
    switch (value.kind) {
      case FubukiValueKind.boolean:
        return value.cast<FubukiBooleanValue>().value;

      case FubukiValueKind.list:
        return value.cast<FubukiListValue>().elements.map(toJson).toList();

      case FubukiValueKind.nullValue:
        return null;

      case FubukiValueKind.number:
        return value.cast<FubukiNumberValue>().numValue;

      case FubukiValueKind.object:
        final FubukiObjectValue obj = value.cast();
        final Map<Object?, Object?> json = <Object, Object>{};
        for (final int i in obj.keys.keys) {
          final Object? key = toJson(obj.keys[i]!);
          final Object? value = toJson(obj.values[i]!);
          json[key] = value;
        }
        return json;

      case FubukiValueKind.string:
        return value.cast<FubukiStringValue>().value;

      default:
        return value.kToString();
    }
  }
}
