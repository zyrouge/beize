import 'exports.dart';

class BeizeNullValue extends BeizeValue {
  BeizeNullValue._();

  @override
  bool get isTruthy => false;

  @override
  int get kHashCode => null.hashCode;

  @override
  final BeizeValueKind kind = BeizeValueKind.nullValue;

  @override
  String kToString() => 'null';

  static final BeizeNullValue value = BeizeNullValue._();
}
