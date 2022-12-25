import 'exports.dart';

class FubukiBooleanValue extends FubukiPrimitiveObjectValue {
  // ignore: avoid_positional_boolean_parameters
  factory FubukiBooleanValue(final bool value) =>
      value ? trueValue : falseValue;

  // ignore: avoid_positional_boolean_parameters
  FubukiBooleanValue._(this.value);

  final bool value;

  FubukiBooleanValue get inversed => FubukiBooleanValue(!value);

  @override
  final FubukiValueKind kind = FubukiValueKind.boolean;

  @override
  FubukiBooleanValue kClone() => FubukiBooleanValue(value);

  @override
  String kToString() => value.toString();

  @override
  bool get isTruthy => value;

  @override
  int get kHashCode => value.hashCode;

  static final FubukiBooleanValue trueValue = FubukiBooleanValue._(true);
  static final FubukiBooleanValue falseValue = FubukiBooleanValue._(false);
}
