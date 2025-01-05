import '../vm/exports.dart';
import 'exports.dart';

class BeizeExceptionClassValue extends BeizePrimitiveClassValue {
  @override
  final String kName = 'ExceptionClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeExceptionValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeExceptionValue? exception = call.argumentAtOrNull(0);
    if (exception != null) {
      return BeizeInterpreterResult.success(exception.kClone());
    }
    final BeizeStringValue message = call.argumentAt(0);
    final BeizeValue stackTrace = call.argumentAt(1);
    final BeizeExceptionValue value = BeizeExceptionValue(
      message.value,
      stackTrace is BeizeNullValue
          ? call.frame.getStackTrace()
          : stackTrace.kToString(),
    );
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<exception class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {}

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {}
}
