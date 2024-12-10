import '../../vm/exports.dart';
import '../exports.dart';

abstract class BeizeNativeClassValue extends BeizeClassValue {
  @override
  final BeizeValueKind kind = BeizeValueKind.nativeClazz;

  BeizeObjectValue kInstantiate(final BeizeCallableCall call);

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) {
    final BeizeObjectValue value = kInstantiate(call);
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<native class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
