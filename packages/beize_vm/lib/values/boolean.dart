import '../vm/exports.dart';
import 'exports.dart';

class BeizeBooleanValue extends BeizePrimitiveObjectValue {
  factory BeizeBooleanValue(final BeizeGlobals globals, final bool value) =>
      value ? globals.trueValue : globals.falseValue;

  // ignore: avoid_positional_boolean_parameters
  BeizeBooleanValue._(this.value);

// new method to prevent multiple instances of just two values
  factory BeizeBooleanValue.create(final bool value) =>
      BeizeBooleanValue._(value);

  final bool value;

  @override
  final String kName = 'Boolean';

  @override
  BeizeBooleanClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.booleanClass;

  @override
  bool kEquals(final BeizeValue other) =>
      other is BeizeBooleanValue && value == other.value;

  @override
  BeizeBooleanValue kClone() => this;

  @override
  String kToString() => value.toString();

  @override
  bool get isTruthy => value;

  @override
  int get kHashCode => value.hashCode;
}
