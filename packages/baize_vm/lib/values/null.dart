import 'exports.dart';

class BaizeNullValue extends BaizeValue {
  BaizeNullValue._();

  @override
  bool get isTruthy => false;

  @override
  int get kHashCode => null.hashCode;

  @override
  final BaizeValueKind kind = BaizeValueKind.nullValue;

  @override
  String kToString() => 'null';

  static final BaizeNullValue value = BaizeNullValue._();
}
