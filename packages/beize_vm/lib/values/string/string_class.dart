import '../exports.dart';

class BeizeStringClassValue extends BeizeNativeClassValue {
  BeizeStringClassValue() {
    setField(
      'fromCodeUnit',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeNumberValue value = call.argumentAt(0);
          return BeizeStringValue(String.fromCharCode(value.intValue));
        },
      ),
    );
    setField(
      'fromCodeUnits',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeListValue value = call.argumentAt(0);
          return BeizeStringValue(
            String.fromCharCodes(
              value.elements.map(
                (final BeizeValue x) => x.cast<BeizeNumberValue>().intValue,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeStringValue;

  @override
  BeizeStringValue kInstantiate(final BeizeCallableCall call) {
    final BeizeValue value = call.argumentAt(0);
    return BeizeStringValue(value.kToString());
  }

  @override
  BeizeStringClassValue kClone() => this;

  @override
  String kToString() => '<string class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
