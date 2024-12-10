import '../../bytecode.dart';
import '../exports.dart';

class BeizeVMClassValue extends BeizeClassValue {
  BeizeVMClassValue(this.constant);

  final BeizeClassConstant constant;

  @override
  final BeizeValueKind kind = BeizeValueKind.clazz;

  @override
  BeizeObjectValue kInstantiate(final BeizeCallableCall call) {
    throw UnimplementedError();
  }

  @override
  BeizeVMClassValue kClone() => BeizeVMClassValue(constant);

  @override
  String kToString() => '<class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
