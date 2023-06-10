import '../values/exports.dart';

class BaizeStack {
  final List<BaizeValue> values = <BaizeValue>[];

  void push(final BaizeValue value) => values.add(value);
  T pop<T extends BaizeValue>() => values.removeLast().cast<T>();
  T top<T extends BaizeValue>() => values.last.cast<T>();

  int get length => values.length;

  @override
  String toString() =>
      'BaizeStack [${values.map((final BaizeValue x) => x.kToString()).join(', ')}]';
}
