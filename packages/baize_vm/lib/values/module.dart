import '../vm/exports.dart';
import 'exports.dart';

class BaizeModuleValue extends BaizePrimitiveObjectValue {
  BaizeModuleValue(this.namespace);

  final BaizeNamespace namespace;

  @override
  BaizeValue get(final BaizeValue key) {
    if (key is BaizeStringValue) {
      final BaizeValue? value = namespace.lookupOrNull(key.value);
      if (value != null) return value;
    }
    return super.get(key);
  }

  @override
  void set(final BaizeValue key, final BaizeValue value) {
    if (key is BaizeStringValue) {
      final BaizeValue? existingValue = namespace.lookupOrNull(key.value);
      if (existingValue != null) {
        namespace.assign(key.value, value);
      }
    }
    return super.set(key, value);
  }

  @override
  final BaizeValueKind kind = BaizeValueKind.module;

  @override
  BaizeModuleValue kClone() => BaizeModuleValue(namespace);

  @override
  String kToString() => kind.code;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => namespace.hashCode;
}
