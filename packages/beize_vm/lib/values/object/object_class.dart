import '../exports.dart';

class BeizeObjectClassValue extends BeizeNativeClassValue {
  BeizeObjectClassValue() {
    setField(
      'fromEntries',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeListValue value = call.argumentAt(0);
          final BeizeObjectValue nValue = BeizeVMObjectValue();
          for (final MapEntry<BeizeValue, BeizeValue> x in value.entries()) {
            nValue.set(x.key, x.value);
          }
          return nValue;
        },
      ),
    );
    setField(
      'apply',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue a = call.argumentAt(0);
          final BeizeObjectValue b = call.argumentAt(1);
          for (final MapEntry<BeizeValue, BeizeValue> x in b.entries()) {
            a.set(x.key, x.value);
          }
          return a;
        },
      ),
    );
    setField(
      'entries',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          final BeizeListValue result = BeizeListValue();
          for (final MapEntry<BeizeValue, BeizeValue> x in value.entries()) {
            final BeizeListValue entry =
                BeizeListValue(<BeizeValue>[x.key, x.value]);
            result.push(entry);
          }
          return result;
        },
      ),
    );
    setField(
      'keys',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.keys());
        },
      ),
    );
    setField(
      'values',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.values());
        },
      ),
    );
    setField(
      'clone',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    setField(
      'deleteProperty',
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
  bool kInstance(final BeizeObjectValue value) => true;

  @override
  BeizeObjectValue kInstantiate(final BeizeCallableCall call) {
    final BeizeObjectValue value = call.argumentAt(0);
    return value.kClone() as BeizeObjectValue;
  }

  @override
  BeizeObjectClassValue kClone() => this;

  @override
  String kToString() => '<object class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
