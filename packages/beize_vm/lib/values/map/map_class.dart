import '../exports.dart';

class BeizeMapClassValue extends BeizeNativeClassValue {
  BeizeMapClassValue() {
    set(
      BeizeStringValue('fromEntries'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeListValue value = call.argumentAt(0);
          final BeizeMapValue nValue = BeizeMapValue();
          for (final BeizeValuePair x in value.entries()) {
            nValue.set(x.key, x.value);
          }
          return nValue;
        },
      ),
    );
    set(
      BeizeStringValue('apply'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue a = call.argumentAt(0);
          final BeizeObjectValue b = call.argumentAt(1);
          for (final BeizeValuePair x in b.entries()) {
            a.set(x.key, x.value);
          }
          return a;
        },
      ),
    );
    set(
      BeizeStringValue('entries'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          final BeizeListValue result = BeizeListValue();
          for (final BeizeValuePair x in value.entries()) {
            result.push(BeizeListValue(<BeizeValue>[x.key, x.value]));
          }
          return result;
        },
      ),
    );
    set(
      BeizeStringValue('keys'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.keys());
        },
      ),
    );
    set(
      BeizeStringValue('values'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.values());
        },
      ),
    );
    set(
      BeizeStringValue('clone'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    set(
      BeizeStringValue('deleteProperty'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          final BeizeValue key = call.argumentAt(1);
          value.delete(key);
          return BeizeNullValue.value;
        },
      ),
    );
  }

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
