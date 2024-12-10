import '../../bytecode.dart';
import '../exports.dart';

class BeizeVMClassValue extends BeizeClassValue {
  BeizeVMClassValue(this.constant);

  final BeizeClassConstant constant;

  @override
  final BeizeValueKind kind = BeizeValueKind.clazz;

  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeClassValue;

  @override
  BeizeObjectValue kInstantiate(final BeizeCallableCall call) {
    throw UnimplementedError();
  }

  @override
  BeizeVMClassValue kClone() => BeizeVMClassValue(constant)..kCopyFrom(this);

  @override
  String kToString() => '<class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
