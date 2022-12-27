import '../vm/exports.dart';
import 'exports.dart';

class FubukiModuleValue extends FubukiPrimitiveObjectValue {
  FubukiModuleValue(this.namespace);

  final FubukiNamespace namespace;

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      final FubukiValue? value = namespace.lookupOrNull(key.value);
      if (value != null) return value;
    }
    return super.get(key);
  }

  @override
  void set(final FubukiValue key, final FubukiValue value) {
    if (key is FubukiStringValue) {
      final FubukiValue? existingValue = namespace.lookupOrNull(key.value);
      if (existingValue != null) {
        namespace.assign(key.value, value);
      }
    }
    return super.set(key, value);
  }

  @override
  final FubukiValueKind kind = FubukiValueKind.module;

  @override
  FubukiModuleValue kClone() => FubukiModuleValue(namespace);

  @override
  String kToString() => kind.code;

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => namespace.hashCode;
}
