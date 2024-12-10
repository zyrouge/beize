import '../../vm/exports.dart';
import '../exports.dart';

class BeizeVMObjectValue extends BeizeNativeObjectValue {
  BeizeVMObjectValue({
    super.fields,
    super.internals,
  });

  @override
  final BeizeValueKind kind = BeizeValueKind.object;

  @override
  BeizeVMObjectValue kClone() => BeizeVMObjectValue()..kCopyFrom(this);

  @override
  String kToString() {
    final StringBuffer buffer = StringBuffer('{');
    bool hasKeys = false;
    for (final MapEntry<String, BeizeValue> x in fields.entries) {
      if (hasKeys) {
        buffer.write(', ');
      }
      hasKeys = true;
      final String value = x.value.kToString();
      buffer.write('${x.key}: $value');
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.objectClass;

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => fields.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
