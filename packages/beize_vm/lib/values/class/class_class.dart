import '../exports.dart';

// what the fuck is this naming
class BeizeClassClassValue extends BeizeNativeClassValue {
  BeizeClassClassValue() {
    setField(
      'of',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return BeizeClassValueUtils.getClass(call.frame.vm, value);
        },
      ),
    );
    setField(
      'isInstance',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeClassValue clazz = call.argumentAt(0);
          final BeizeValue value = call.argumentAt(1);
          return BeizeClassValueUtils.isClassInstance(clazz, value)
              ? call.frame.vm.globals.trueValue
              : call.frame.vm.globals.falseValue;
        },
      ),
    );
  }

  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeClassValue;

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
