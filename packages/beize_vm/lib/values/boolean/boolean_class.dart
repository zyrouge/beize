import '../exports.dart';

class BeizeBooleanClassValue extends BeizeNativeClassValue {
  @override
  BeizeBooleanValue kInstantiate(final BeizeCallableCall call) {
    final BeizeValue value = call.argumentAt(0);
    return BeizeBooleanValue(value.isTruthy);
  }

  @override
  BeizeBooleanClassValue kClone() => this;

  @override
  String kToString() => '<boolean class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
