import 'exports.dart';

class BeizeObjectValue extends BeizePrimitiveObjectValue {
  BeizeObjectValue({
    super.fields,
  });

  @override
  final BeizeValueKind kind = BeizeValueKind.object;

  @override
  BeizeObjectValue kClone() => BeizeObjectValue(
        fields: Map<int, List<BeizeObjectValueField>>.of(fields),
      );

  @override
  String kToString() {
    final StringBuffer buffer = StringBuffer('{');
    bool hasValues = false;
    for (final List<BeizeObjectValueField> x in fields.values) {
      for (final BeizeObjectValueField y in x) {
        if (hasValues) {
          buffer.write(', ');
        }
        hasValues = true;
        final String key = y.key.kToString();
        final String value = y.value.kToString();
        buffer.write('$key: $value');
      }
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool get isTruthy => fields.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
