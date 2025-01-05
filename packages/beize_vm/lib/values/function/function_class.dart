import '../../vm/exports.dart';
import '../exports.dart';

class BeizeFunctionClassValue extends BeizePrimitiveClassValue {
  BeizeFunctionClassValue() {
    bindClassFields(fields);
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'FunctionClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeFunctionValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeFunctionClassValue value = call.argumentAt(0);
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<function class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('call'),
      BeizeNativeFunctionValue(
        (final BeizeFunctionCall call) {
          final BeizeCallableValue object = call.argumentAt(0);
          final BeizeListValue arguments = call.argumentAt(1);
          return call.frame.callValue(object, arguments.elements);
        },
      ),
    );
  }

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('call'),
      BeizeNativeFunctionValue(
        (final BeizeFunctionCall call) {
          final BeizeListValue object = call.argumentAt(0);
          final BeizeListValue arguments = call.argumentAt(1);
          return call.frame.callValue(object, arguments.elements);
        },
      ),
    );
  }
}
