import '../vm/exports.dart';
import 'exports.dart';

class BeizeObjectClassValue extends BeizePrimitiveClassValue {
  BeizeObjectClassValue() {
    bindClassFields(fields);
  }

  @override
  final String kName = 'ObjectClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) => true;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeObjectClassValue value = call.argumentAt(0);
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<object class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    fields.set(
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
    fields.set(
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
    fields.set(
      BeizeStringValue('entries'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return value.kEntries();
        },
      ),
    );
    fields.set(
      BeizeStringValue('keys'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.keys());
        },
      ),
    );
    fields.set(
      BeizeStringValue('values'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return BeizeListValue(value.values());
        },
      ),
    );
    fields.set(
      BeizeStringValue('clone'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    fields.set(
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
  }
}
