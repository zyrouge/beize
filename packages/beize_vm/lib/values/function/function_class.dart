import '../exports.dart';

class BeizeFunctionClassValue extends BeizeNativeClassValue {
  BeizeFunctionClassValue() {
    setField(
      'call',
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
  bool kInstance(final BeizeObjectValue value) => value is BeizeCallableValue;

  @override
  BeizeCallableValue kInstantiate(final BeizeCallableCall call) {
    final BeizeCallableValue value = call.argumentAt(0);
    return value.kClone() as BeizeCallableValue;
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
