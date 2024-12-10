import '../../vm/exports.dart';
import '../exports.dart';

class BeizeListClassValue extends BeizeNativeClassValue {
  BeizeListClassValue() {
    setField(
      'generate',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final int length = call.argumentAt<BeizeNumberValue>(0).intValue;
          final BeizeCallableValue predicate = call.argumentAt(1);
          final BeizeListValue result = BeizeListValue();
          for (int i = 0; i < length; i++) {
            final BeizeInterpreterResult x = predicate.kCall(
              BeizeCallableCall(
                frame: call.frame,
                arguments: <BeizeValue>[BeizeNumberValue(i.toDouble())],
              ),
            );
            result.push(x.unwrapUnsafe());
          }
          return result;
        },
      ),
    );
    setField(
      'filled',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final int length = call.argumentAt<BeizeNumberValue>(0).intValue;
          final BeizeValue value = call.argumentAt(1);
          final BeizeListValue result =
              BeizeListValue(List<BeizeValue>.filled(length, value));
          return result;
        },
      ),
    );
  }

  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeListValue;

  @override
  BeizeListValue kInstantiate(final BeizeCallableCall call) {
    final BeizeListValue value = call.argumentAt(0);
    return value.kClone();
  }

  @override
  BeizeListClassValue kClone() => this;

  @override
  String kToString() => '<list class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
