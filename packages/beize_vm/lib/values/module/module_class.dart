import '../exports.dart';

class BeizeModuleClassValue extends BeizeNativeClassValue {
  @override
  bool kInstance(final BeizeObjectValue value) => true;

  @override
  BeizeObjectValue kInstantiate(final BeizeCallableCall call) =>
      throw UnimplementedError();

  @override
  BeizeModuleClassValue kClone() => this;

  @override
  String kToString() => '<module class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
