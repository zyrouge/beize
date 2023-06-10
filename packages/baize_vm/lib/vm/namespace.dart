import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'natives/exports.dart';

class BaizeNamespace {
  BaizeNamespace([this.parent]);

  factory BaizeNamespace.withNatives() {
    final BaizeNamespace namespace = BaizeNamespace();
    BaizeNatives.bind(namespace);
    return namespace;
  }

  final BaizeNamespace? parent;
  final Map<String, BaizeValue> values = <String, BaizeValue>{};

  BaizeValue lookup(final String name) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw BaizeRuntimeExpection.undefinedVariable(name);
      }
      return parent!.lookup(name);
    }
    return values[name]!;
  }

  BaizeValue? lookupOrNull(final String name) =>
      values[name] ?? parent?.lookup(name);

  void declare(final String name, final BaizeValue value) {
    if (values.containsKey(name)) {
      throw BaizeRuntimeExpection.cannotRedecalreVariable(name);
    }
    values[name] = value;
  }

  void assign(final String name, final BaizeValue value) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw BaizeRuntimeExpection.undefinedVariable(name);
      }
      return parent!.assign(name, value);
    }
    values[name] = value;
  }

  BaizeNamespace get enclosed => BaizeNamespace(this);
}
