import '../exports.dart';

abstract class BeizeNativeClassValue extends BeizeClassValue {
  @override
  final BeizeValueKind kind = BeizeValueKind.nativeClazz;

  @override
  String kToString() => '<native class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
