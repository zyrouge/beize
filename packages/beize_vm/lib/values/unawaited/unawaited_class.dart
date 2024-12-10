import '../exports.dart';

class BeizeUnawaitedClassValue extends BeizeNativeClassValue {
  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeUnawaitedValue;

  @override
  BeizeUnawaitedValue kInstantiate(final BeizeCallableCall call) {
    final BeizeUnawaitedValue value = call.argumentAt(0);
    return value.kClone();
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
