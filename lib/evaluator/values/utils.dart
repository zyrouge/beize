import 'exports.dart';

abstract class OutreValueUtils {
  static OutreValue toOutreValue(final Object object) {
    if (object is OutreValue) {
      return object;
    }
    if (object is OutreConvertableValue) {
      return object.toOutreValue();
    }
    return OutreStringValue(object.toString());
  }

  static Future<String> stringify(final Object object) async {
    if (object is OutreValue) {
      final OutreValue result = await object
          .getPropertyOfKey(OutreValueProperties.kToString)
          .cast<OutreFunctionValue>()
          .call(<OutreValue>[]);
      return result.cast<OutreStringValue>().value;
    }
    return object.toString();
  }

  static Future<String> stringifyMany(
    final List<Object> objects, {
    final String? start,
    final String? end,
  }) async {
    final List<String> values = <String>[];
    for (final Object x in objects) {
      values.add(await stringify(x));
    }
    return '${start ?? ''}${values.join(', ')}${end ?? ''}';
  }

  static bool equals(final OutreValue a, final OutreValue b) {
    if (a is OutreNullValue && b is OutreNullValue) {
      return true;
    }
    if (a is OutreBooleanValue && b is OutreBooleanValue) {
      return a.value == b.value;
    }
    if (a is OutreNumberValue && b is OutreNumberValue) {
      return a.value == b.value;
    }
    if (a is OutreStringValue && b is OutreStringValue) {
      return a.value == b.value;
    }
    return false;
  }
}
