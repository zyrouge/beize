import '../vm/exports.dart';
import 'exports.dart';

class BeizeModuleValue extends BeizePrimitiveObjectValue {
  BeizeModuleValue(this.namespace);

  final BeizeNamespace namespace;

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeStringValue) {
      final BeizeValue? value = namespace.lookupOrNull(key.value);
      if (value != null) return value;
    }
    return super.get(key);
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
  final BeizeValueKind kind = BeizeValueKind.module;

  @override
  BeizeModuleValue kClone() => BeizeModuleValue(namespace);

  @override
  String kToString() => kind.code;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => namespace.hashCode;
}
