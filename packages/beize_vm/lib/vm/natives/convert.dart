import 'dart:convert';
import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeConvertNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('newBytesList'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          if (value is BeizeNullValue) {
            return newBytesList(<int>[]);
          }
          final BeizeListValue bytes = value.cast();
          return newBytesList(
            bytes.elements
                .map(
                  (final BeizeValue x) => x.cast<BeizeNumberValue>().intValue,
                )
                .toList(),
          );
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeAscii'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return newBytesList(ascii.encode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeAscii'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeObjectValue input = call.argumentAt(0);
          return BeizeStringValue(ascii.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeBase64'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeObjectValue input = call.argumentAt(0);
          return BeizeStringValue(base64Encode(toBytes(input)));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeBase64'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return newBytesList(base64Decode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeLatin1'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return newBytesList(latin1.encode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeLatin1'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeObjectValue input = call.argumentAt(0);
          return BeizeStringValue(latin1.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeUtf8'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return newBytesList(utf8.encode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeUtf8'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeObjectValue input = call.argumentAt(0);
          return BeizeStringValue(utf8.decode(toBytes(input)));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeJson'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeValue input = call.argumentAt(0);
          return BeizeStringValue(jsonEncode(toJson(input)));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeJson'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return fromJson(jsonDecode(input.value));
        },
      ),
    );
    namespace.declare('Convert', value);
  }

  static List<int> toBytes(final BeizeObjectValue bytesList) {
    if (bytesList.internals.containsKey('bytes')) {
      return bytesList.internals['bytes'] as List<int>;
    }
    throw BeizeNativeException('Object is not a bytes list');
  }

  static BeizeValue newBytesList(final List<int> bytes) {
    final BeizeObjectValue bytesList = BeizeObjectValue();
    bytesList.internals['bytes'] = bytes;
    bytesList.set(
      BeizeStringValue('bytes'),
      BeizeNativeFunctionValue.sync(
        (final _) => BeizeListValue(
          bytes.map((final int x) => BeizeNumberValue(x.toDouble())).toList(),
        ),
      ),
    );
    return bytesList;
  }

  static BeizeValue fromJson(final Object? json) {
    if (json is bool) return BeizeBooleanValue(json);
    if (json == null) return BeizeNullValue.value;
    if (json is int) return BeizeNumberValue(json.toDouble());
    if (json is double) return BeizeNumberValue(json);
    if (json is String) return BeizeStringValue(json);
    if (json is List<dynamic>) {
      final BeizeListValue list = BeizeListValue();
      for (final Object? x in json) {
        list.push(fromJson(x));
      }
      return list;
    }
    if (json is Map<dynamic, dynamic>) {
      final BeizeObjectValue obj = BeizeObjectValue();
      for (final MapEntry<Object?, Object?> x in json.entries) {
        final BeizeValue key = fromJson(x.key);
        final BeizeValue value = fromJson(x.value);
        obj.set(key, value);
      }
      return obj;
    }
    return BeizeStringValue(json.toString());
  }

  static Object? toJson(final BeizeValue value) {
    switch (value.kind) {
      case BeizeValueKind.boolean:
        return value.cast<BeizeBooleanValue>().value;

      case BeizeValueKind.list:
        return value.cast<BeizeListValue>().elements.map(toJson).toList();

      case BeizeValueKind.nullValue:
        return null;

      case BeizeValueKind.number:
        return value.cast<BeizeNumberValue>().numValue;

      case BeizeValueKind.object:
        final BeizeObjectValue obj = value.cast();
        final Map<Object?, Object?> json = <Object?, Object?>{};
        for (final MapEntry<BeizeValue, BeizeValue> x in obj.entries()) {
          final Object? key = toJson(x.key);
          final Object? value = toJson(x.value);
          json[key] = value;
        }
        return json;

      case BeizeValueKind.string:
        return value.cast<BeizeStringValue>().value;

      default:
        return value.kToString();
    }
  }
}
