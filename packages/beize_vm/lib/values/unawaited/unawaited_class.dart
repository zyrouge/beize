import '../exports.dart';

class BeizeUnawaitedClassValue extends BeizeNativeClassValue {
  @override
  BeizeFunctionValue kInstantiate(final BeizeCallableCall call) {
    final BeizeFunctionValue value = call.argumentAt(0);
    return value;
  }

  @override
  BeizeUnawaitedClassValue kClone() => this;

  @override
  String kToString() => '<unawaited class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
