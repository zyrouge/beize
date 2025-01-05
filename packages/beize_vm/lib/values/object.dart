import '../vm/exports.dart';
import 'exports.dart';

class BeizeObjectValue extends BeizePrimitiveObjectValue {
  BeizeObjectValue({
    super.fields,
  });

  @override
  final String kName = 'Object';

  @override
  BeizePrimitiveClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.objectClass;

  @override
  BeizeObjectValue kClone() => BeizeObjectValue(fields: fields.clone());

  @override
  String kToString() {
    final StringBuffer buffer = StringBuffer('{');
    bool hasValues = false;
    for (final BeizeObjectValueField x in fields.fieldEntries) {
      if (hasValues) {
        buffer.write(', ');
      }
      hasValues = true;
      final String key = x.key.kToString();
      final String value = x.value.kToString();
      buffer.write('$key: $value');
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool get isTruthy => fields.map.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
