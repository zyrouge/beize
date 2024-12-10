import '../../vm/exports.dart';
import '../exports.dart';

class BeizeBooleanValue extends BeizeNativeObjectValue {
  BeizeBooleanValue(this.value);

  final bool value;

  @override
  final BeizeValueKind kind = BeizeValueKind.boolean;

  @override
  BeizeBooleanValue kClone() => BeizeBooleanValue(value);

  @override
  String kToString() => value.toString();

  @override
  BeizeClassValue? kClassInternal(final BeizeVM vm) => vm.globals.booleanClass;

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => value;

  @override
  int get kHashCode => value.hashCode;
}
