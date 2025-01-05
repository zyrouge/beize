import 'dart:convert';
import '../../values/exports.dart';
import '../exports.dart';

abstract class BeizeConvertNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('encodeAscii'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return BeizeBytesListValue(ascii.encode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeAscii'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeBytesListValue input = call.argumentAt(0);
          return BeizeStringValue(ascii.decode(input.bytes));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeBase64'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeBytesListValue input = call.argumentAt(0);
          return BeizeStringValue(base64Encode(input.bytes));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeBase64'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return BeizeBytesListValue(base64Decode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeLatin1'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return BeizeBytesListValue(latin1.encode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeLatin1'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeBytesListValue input = call.argumentAt(0);
          return BeizeStringValue(latin1.decode(input.bytes));
        },
      ),
    );
    value.set(
      BeizeStringValue('encodeUtf8'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return BeizeBytesListValue(utf8.encode(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('decodeUtf8'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeBytesListValue input = call.argumentAt(0);
          return BeizeStringValue(utf8.decode(input.bytes));
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
          return fromJson(call.frame.vm.globals, jsonDecode(input.value));
        },
      ),
    );
    namespace.declare('Convert', value);
  }

  static BeizeValue fromJson(final BeizeGlobals globals, final Object? json) {
    if (json is bool) return BeizeBooleanValue(globals, json);
    if (json == null) return BeizeNullValue.value;
    if (json is int) return BeizeNumberValue(json.toDouble());
    if (json is double) return BeizeNumberValue(json);
    if (json is String) return BeizeStringValue(json);
    if (json is List<dynamic>) {
      final BeizeListValue list = BeizeListValue();
      for (final Object? x in json) {
        list.push(fromJson(globals, x));
      }
      return list;
    }
    if (json is Map<dynamic, dynamic>) {
      final BeizeObjectValue obj = BeizeObjectValue();
      for (final MapEntry<Object?, Object?> x in json.entries) {
        final BeizeValue key = fromJson(globals, x.key);
        final BeizeValue value = fromJson(globals, x.value);
        obj.set(key, value);
      }
      return obj;
    }
    return BeizeStringValue(json.toString());
  }

  static dynamic toJson(final BeizeValue value) {
    if (value is BeizeNullValue) {
      return null;
    }
    if (value is BeizeBooleanValue) {
      return value.value;
    }
    if (value is BeizeStringValue) {
      return value.value;
    }
    if (value is BeizeNumberValue) {
      return value.value;
    }
    if (value is BeizeListValue) {
      return value.elements.map(toJson).toList();
    }
    if (value is BeizeObjectValue) {
      final BeizeObjectValue obj = value.cast();
      final Map<dynamic, dynamic> json = <dynamic, dynamic>{};
      for (final MapEntry<BeizeValue, BeizeValue> x in obj.entries()) {
        final dynamic key = toJson(x.key);
        final dynamic value = toJson(x.value);
        json[key] = value;
      }
      return json;
    }
    return value.kToString();
  }
}
