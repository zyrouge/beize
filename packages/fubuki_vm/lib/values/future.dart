import 'exports.dart';

class FubukiFutureValue extends FubukiPrimitiveObjectValue {
  FubukiFutureValue(this.value);

  final Future<FubukiValue> value;

  @override
  final FubukiValueKind kind = FubukiValueKind.future;

  @override
  FubukiFutureValue kClone() => FubukiFutureValue(value);

  @override
  String kToString() => value.toString();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => value.hashCode;
}
