import '../errors/runtime_exception.dart';
import '../values/exports.dart';
import 'natives/exports.dart';

class FubukiNamespace {
  FubukiNamespace([this.parent]);

  factory FubukiNamespace.withNatives() {
    final FubukiNamespace namespace = FubukiNamespace();
    FubukiNatives.bind(namespace);
    return namespace;
  }

  final FubukiNamespace? parent;
  final Map<String, FubukiValue> values = <String, FubukiValue>{};

  FubukiValue lookup(final String name) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw FubukiRuntimeExpection.undefinedVariable(name);
      }
      return parent!.lookup(name);
    }
    return values[name]!;
  }

  void declare(final String name, final FubukiValue value) {
    if (values.containsKey(name)) {
      throw FubukiRuntimeExpection.cannotRedecalreVariable(name);
    }
    values[name] = value;
  }

  void assign(final String name, final FubukiValue value) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw FubukiRuntimeExpection.undefinedVariable(name);
      }
      return parent!.assign(name, value);
    }
    values[name] = value;
  }

  FubukiNamespace get enclosed => FubukiNamespace(this);
}
