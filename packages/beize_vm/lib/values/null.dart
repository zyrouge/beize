import 'exports.dart';

class BeizeNullValue extends BeizeValue {
  BeizeNullValue._();

  @override
  bool get isTruthy => false;

  @override
  int get kHashCode => null.hashCode;

  @override
  final String kName = 'Null';

  @override
  bool kEquals(final BeizeValue other) => other is BeizeNullValue;

  @override
  String kToString() => 'null';

  static final BeizeNullValue value = BeizeNullValue._();
}
