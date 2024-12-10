import '../exports.dart';

class BeizeMapClassValue extends BeizeNativeClassValue {
  BeizeMapClassValue() {
    setField(
      'fromEntries',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeListValue value = call.argumentAt(0);
          final BeizeMapValue nValue = BeizeMapValue();
          for (final MapEntry<BeizeValue, BeizeValue> x in value.entries()) {
            nValue.set(x.key, x.value);
          }
          return nValue;
        },
      ),
    );
  }

  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeMapValue;

  @override
  BeizeMapValue kInstantiate(final BeizeCallableCall call) {
    final BeizeMapValue value = call.argumentAt(0);
    return value.kClone();
  }

  @override
  BeizeMapClassValue kClone() => this;

  @override
  String kToString() => '<map class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
