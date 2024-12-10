import 'exports.dart';

class BeizeBooleanValue extends BeizePrimitiveObjectValue {
  // ignore: avoid_positional_boolean_parameters
  factory BeizeBooleanValue(final bool value) => value ? trueValue : falseValue;

  // ignore: avoid_positional_boolean_parameters
  BeizeBooleanValue._(this.value);

  final bool value;

  @override
  final BeizeValueKind kind = BeizeValueKind.boolean;

  BeizeBooleanValue get inversed => BeizeBooleanValue(!value);

  @override
  BeizeBooleanValue kClone() => BeizeBooleanValue(value);

  @override
  String kToString() => value.toString();

  @override
  bool get isTruthy => value;

  @override
  int get kHashCode => value.hashCode;

  static final BeizeBooleanValue trueValue = BeizeBooleanValue._(true);
  static final BeizeBooleanValue falseValue = BeizeBooleanValue._(false);
}
