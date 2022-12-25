import 'exports.dart';

class FubukiStringValue extends FubukiPrimitiveObjectValue {
  FubukiStringValue(this.value);

  final String value;

  @override
  final FubukiValueKind kind = FubukiValueKind.string;

  @override
  FubukiStringValue kClone() => FubukiStringValue(value);

  @override
  String kToString() => value;

  @override
  bool get isTruthy => value.isNotEmpty;

  @override
  int get kHashCode => value.hashCode;
}
