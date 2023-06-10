import 'exports.dart';

class BaizeBooleanValue extends BaizePrimitiveObjectValue {
  // ignore: avoid_positional_boolean_parameters
  factory BaizeBooleanValue(final bool value) =>
      value ? trueValue : falseValue;

  // ignore: avoid_positional_boolean_parameters
  BaizeBooleanValue._(this.value);

  final bool value;

  BaizeBooleanValue get inversed => BaizeBooleanValue(!value);

  @override
  final BaizeValueKind kind = BaizeValueKind.boolean;

  @override
  BaizeBooleanValue kClone() => BaizeBooleanValue(value);

  @override
  String kToString() => value.toString();

  @override
  bool get isTruthy => value;

  @override
  int get kHashCode => value.hashCode;

  static final BaizeBooleanValue trueValue = BaizeBooleanValue._(true);
  static final BaizeBooleanValue falseValue = BaizeBooleanValue._(false);
}
