import '../vm/exports.dart';
import 'exports.dart';

class BeizeVMObjectValue extends BeizePrimitiveObjectValue {
  BeizeVMObjectValue({
    required final BeizeVMClassValue kClass,
    super.fields,
  }) : _kClass = kClass;

  final BeizeVMClassValue _kClass;

  @override
  BeizeVMClassValue kClass(final BeizeCallFrame frame) => _kClass;

  @override
  BeizeVMObjectValue kClone() =>
      BeizeVMObjectValue(kClass: _kClass, fields: fields.clone());

  @override
  String kToString() {
    final BeizeValue? function = getAlongClassOrNull(
      _kClass,
      BeizeStringValue(BeizeVMClassValue.kToStringFunction),
    );
    if (function != null) {
      return BeizeCallFrame.kCallValueFrameless(_kClass.vm, function)
          .unwrapUnsafe()
          .kToString();
    }
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
  String get kName {
    final BeizeValue? function = _kClass.getAlongClassOrNull(
      _kClass,
      BeizeStringValue(BeizeVMClassValue.kToStringFunction),
    );
    if (function != null) {
      return BeizeCallFrame.kCallValueFrameless(_kClass.vm, function)
          .unwrapUnsafe()
          .kToString();
    }
    return 'Object';
  }

  @override
  bool get isTruthy => fields.map.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
