import '../exports.dart';

class BeizeObjectClassValue extends BeizeNativeClassValue {
  @override
  BeizeObjectValue kInstantiate(final BeizeCallableCall call) {
    final BeizeObjectValue value = call.argumentAt(0);
    return value;
  }

  @override
  BeizeObjectClassValue kClone() => this;

  @override
  String kToString() => '<object class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
