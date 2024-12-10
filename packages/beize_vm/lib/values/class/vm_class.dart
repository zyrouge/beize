import '../../vm/exports.dart';
import '../exports.dart';

class BeizeVMClassValue extends BeizeClassValue {
  late final BeizeClassValue? parentClass;
  late final BeizeCallableValue constructor;

  @override
  final BeizeValueKind kind = BeizeValueKind.clazz;

  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeClassValue;

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) =>
      constructor.kCall(call);

  @override
  BeizeVMClassValue kClone() => BeizeVMClassValue()
    ..parentClass = parentClass
    ..constructor = constructor
    ..kCopyFrom(this);

  @override
  String kToString() => '<class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => Object.hash(parentClass, constructor);
}
