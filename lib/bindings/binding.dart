class OutreBindingArguments {
  const OutreBindingArguments(this.values);

  final List<dynamic> values;

  T at<T>(final int index) => values[index] as T;
}

typedef OutreBindingCall = dynamic Function(OutreBindingArguments args);

class OutreBinding {
  const OutreBinding({
    required this.name,
    required this.call,
  });

  final String name;
  final OutreBindingCall call;
}
