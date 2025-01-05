import '../vm/exports.dart';
import 'exports.dart';

class BeizeBooleanClassValue extends BeizePrimitiveClassValue {
  BeizeBooleanClassValue() {
    bindClassFields(fields);
  }

  @override
  final String kName = 'BooleanClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeBooleanValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeBooleanClassValue value = call.argumentAt(0);
    return BeizeInterpreterResult.success(value.kClone());
  }

  @override
  String kToString() => '<boolean class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          return BeizeBooleanValue(call.frame.vm.globals, value.isTruthy);
        },
      ),
    );
  }
}
