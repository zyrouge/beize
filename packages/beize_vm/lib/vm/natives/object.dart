import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeObjectNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      BeizeStringValue('fromEntries'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeListValue value = call.argumentAt(0);
          final BeizeObjectValue nValue = BeizeObjectValue();
          for (final MapEntry<BeizeValue, BeizeValue> x in value.entries()) {
            nValue.set(x.key, x.value);
          }
          return nValue;
        },
      ),
    );
    value.set(
      BeizeStringValue('apply'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue a = call.argumentAt(0);
          final BeizePrimitiveObjectValue b = call.argumentAt(1);
          for (final MapEntry<BeizeValue, BeizeValue> x in b.entries()) {
            a.set(x.key, x.value);
          }
          return a;
        },
      ),
    );
    value.set(
      BeizeStringValue('entries'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return entries(value);
        },
      ),
    );
    value.set(
      BeizeStringValue('keys'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.keys());
        },
      ),
    );
    value.set(
      BeizeStringValue('values'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.values());
        },
      ),
    );
    value.set(
      BeizeStringValue('clone'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      BeizeStringValue('deleteProperty'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          final BeizeValue key = call.argumentAt(1);
          value.delete(key);
          return BeizeNullValue.value;
        },
      ),
    );
    namespace.declare('Object', value);
  }

  static BeizeListValue entries(final BeizePrimitiveObjectValue value) {
    final BeizeListValue nValue = BeizeListValue();
    for (final MapEntry<BeizeValue, BeizeValue> x in value.entries()) {
      nValue.push(BeizeListValue(<BeizeValue>[x.key, x.value]));
    }
    return nValue;
  }
}
