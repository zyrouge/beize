import '../values/exports.dart';

class BeizeStack {
  final List<BeizeValue> values = <BeizeValue>[];

  void push(final BeizeValue value) => values.add(value);
  T pop<T extends BeizeValue>() => values.removeLast().cast<T>();
  T top<T extends BeizeValue>() => values.last.cast<T>();

  int get length => values.length;

  @override
  String toString() =>
      'BeizeStack [${values.map((final BeizeValue x) => x.kToString()).join(', ')}]';
}
