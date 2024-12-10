import '../../../vm/exports.dart';
import '../../exports.dart';

typedef BeizeNativeExecuteFunction = BeizeInterpreterResult Function(
  BeizeCallableCall call,
);

class BeizeNativeExecuteFunctionValue extends BeizeNativeFunctionValue {
  BeizeNativeExecuteFunctionValue(this.function) : super.internal();

  final BeizeNativeExecuteFunction function;

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) {
    final BeizeInterpreterResult result = function(call);
    return result;
  }

  @override
  BeizeNativeFunctionValue kClone() =>
      BeizeNativeExecuteFunctionValue(function);

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
