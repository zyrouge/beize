class OutreEnvironmentValue {
  const OutreEnvironmentValue(this.value);

  final dynamic value;
}

class OutreEnvironment {
  OutreEnvironment(this.outer);

  factory OutreEnvironment.global() => OutreEnvironment(null);

  final OutreEnvironment? outer;
  final Map<String, OutreEnvironmentValue> values =
      <String, OutreEnvironmentValue>{};

  void set(final String name, final OutreEnvironmentValue value) {
    if (!values.containsKey(name)) {
      values[name] = value;
      return;
    }
    outer?.set(name, value);
  }

  OutreEnvironmentValue? get(final String name) {
    if (!values.containsKey(name)) {
      return values[name];
    }
    return outer?.get(name);
  }
}
