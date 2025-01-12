import '../vm/exports.dart';
import 'exports.dart';

class BeizeModuleValue extends BeizePrimitiveObjectValue {
  BeizeModuleValue(this.namespace);

  final BeizeNamespace namespace;

  @override
  final String kName = 'Module';

  @override
  BeizeValue? getOrNull(final BeizeValue key) {
    if (key is BeizeStringValue) {
      final BeizeValue? value = namespace.lookupOrNull(key.value);
      if (value != null) return value;
    }
    return super.getOrNull(key);
  }

  @override
  void set(final BeizeValue key, final BeizeValue value) {
    if (key is BeizeStringValue) {
      final BeizeValue? existingValue = namespace.lookupOrNull(key.value);
      if (existingValue != null) {
        namespace.assign(key.value, value);
      }
    }
    return super.set(key, value);
  }

  @override
  BeizeClassValue kClass(final BeizeCallFrame frame) => frame.vm.globals.clazz;

  @override
  BeizeModuleValue kClone() => BeizeModuleValue(namespace);

  @override
  String kToString() => kName;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => namespace.hashCode;
}
