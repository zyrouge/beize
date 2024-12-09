import '../exports.dart';

class BeizeFunctionClassValue extends BeizeNativeClassValue {
  BeizeFunctionClassValue() {
    set(
      BeizeStringValue('call'),
      BeizeNativeFunctionValue(
        (final BeizeCallableCall call) {
          final BeizeCallableValue function = call.argumentAt(0);
          final BeizeListValue arguments = call.argumentAt(1);
          return call.frame.callValue(function, arguments.elements);
        },
      ),
    );
  }

  @override
  BeizeCallableValue kInstantiate(final BeizeCallableCall call) {
    final BeizeCallableValue value = call.argumentAt(0);
    return value;
  }

  @override
  BeizeFunctionClassValue kClone() => this;

  @override
  String kToString() => '<function class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
