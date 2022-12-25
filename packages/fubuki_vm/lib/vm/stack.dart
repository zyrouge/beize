import '../values/exports.dart';

class FubukiStack {
  final List<FubukiValue> values = <FubukiValue>[];

  void push(final FubukiValue value) => values.add(value);
  T pop<T extends FubukiValue>() => values.removeLast().cast<T>();
  T top<T extends FubukiValue>() => values.last.cast<T>();

  int get length => values.length;

  @override
  String toString() =>
      'FubukiStack [${values.map((final FubukiValue x) => x.kToString()).join(', ')}]';
}
