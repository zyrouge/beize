import 'values/exports.dart';

class OutreEnvironment {
  OutreEnvironment(this.outer);

  final OutreEnvironment? outer;
  final Map<String, OutreValue> values = <String, OutreValue>{};

  void declare(final String name, final OutreValue value) {
    if (!values.containsKey(name)) {
      throw Exception('Already declared');
    }
    values[name] = value;
  }

  void assign(final String name, final OutreValue value) {
    if (values.containsKey(name)) {
      values[name] = value;
      return;
    }
    if (outer == null) {
      throw Exception('Variable not found');
    }
    outer!.assign(name, value);
  }

  OutreValue get(final String name) {
    if (!values.containsKey(name)) {
      return values[name]!;
    }
    if (outer == null) {
      throw Exception('Variable not found');
    }
    return outer!.get(name);
  }
}
