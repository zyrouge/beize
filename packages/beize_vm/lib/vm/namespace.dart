import '../errors/runtime_exception.dart';
import '../values/exports.dart';

class BeizeNamespace {
  BeizeNamespace([this.parent]);

  final BeizeNamespace? parent;
  final Map<String, BeizeValue> values = <String, BeizeValue>{};

  BeizeValue lookup(final String name) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw BeizeRuntimeException.undefinedVariable(name);
      }
      return parent!.lookup(name);
    }
    return values[name]!;
  }

  BeizeValue? lookupOrNull(final String name) =>
      values[name] ?? parent?.lookupOrNull(name);

  void declare(final String name, final BeizeValue value) {
    if (values.containsKey(name)) {
      throw BeizeRuntimeException.cannotRedeclareVariable(name);
    }
    values[name] = value;
  }

  void assign(final String name, final BeizeValue value) {
    if (!values.containsKey(name)) {
      if (parent == null) {
        throw BeizeRuntimeException.undefinedVariable(name);
      }
      return parent!.assign(name, value);
    }
    values[name] = value;
  }

  BeizeNamespace get enclosed => BeizeNamespace(this);
}
