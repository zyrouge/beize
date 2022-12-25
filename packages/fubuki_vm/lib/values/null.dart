import 'exports.dart';

class FubukiNullValue extends FubukiValue {
  FubukiNullValue._();

  @override
  bool get isTruthy => false;

  @override
  int get kHashCode => null.hashCode;

  @override
  final FubukiValueKind kind = FubukiValueKind.nullValue;

  @override
  String kToString() => 'null';

  static final FubukiNullValue value = FubukiNullValue._();
}
