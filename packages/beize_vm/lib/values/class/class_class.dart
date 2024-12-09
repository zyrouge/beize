import '../exports.dart';

// what the fuck is this naming
class BeizeClassClassValue extends BeizeNativeClassValue {
  BeizeClassClassValue() {
    set(
      BeizeStringValue('of'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return value.kClassInternal(call.frame.vm) ?? value.kClass;
        },
      ),
    );
  }

  @override
  BeizeClassValue kInstantiate(final BeizeCallableCall call) {
    final BeizeClassValue value = call.argumentAt(0);
    return value;
  }

  @override
  BeizeClassClassValue kClone() => this;

  @override
  String kToString() => '<class>';

  @override
  BeizeClassValue get kClass => this;
}
