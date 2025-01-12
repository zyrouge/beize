import '../vm/exports.dart';
import 'exports.dart';

class BeizeVMObjectValue extends BeizePrimitiveObjectValue {
  BeizeVMObjectValue({
    required final BeizeVMClassValue kClass,
    this.parentVMObject,
    super.fields,
  }) : kClass_ = kClass;

  final BeizeVMClassValue kClass_;
  final BeizeVMObjectValue? parentVMObject;

  @override
  BeizeValue? getOrNull(final BeizeValue key) =>
      super.getOrNull(key) ?? parentVMObject?.getOrNull(key);

  @override
  BeizeVMClassValue kClass(final BeizeCallFrame frame) => kClass_;

  @override
  BeizeVMObjectValue kClone() => BeizeVMObjectValue(
        kClass: kClass_,
        fields: fields.clone(),
        parentVMObject: parentVMObject?.kClone(),
      );

  @override
  String kToString() {
    final BeizeValue? function = getAlongClassOrNull(
      kClass_,
      BeizeStringValue(BeizeVMClassValue.kToStringFunction),
    );
    if (function != null) {
      return BeizeCallFrame.kCallValueFrameless(kClass_.vm, function)
          .unwrapUnsafe()
          .kToString();
    }
    final String? name = kNameFromNameFunction();
    if (name != null) {
      return name;
    }
    final String? className = kClass_.kNameFromNameFunction();
    if (className != null) {
      return '<instance $className>';
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

  String? kNameFromNameFunction() {
    final BeizeValue? function = kClass_.getAlongClassOrNull(
      kClass_,
      BeizeStringValue(BeizeVMClassValue.kToStringFunction),
    );
    if (function == null) {
      return null;
    }
    return BeizeCallFrame.kCallValueFrameless(kClass_.vm, function)
        .unwrapUnsafe()
        .kToString();
  }

  @override
  String get kName => kNameFromNameFunction() ?? 'Object';

  @override
  bool get isTruthy => fields.map.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
