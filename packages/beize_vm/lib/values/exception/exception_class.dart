import '../exports.dart';

class BeizeExceptionClassValue extends BeizeNativeClassValue {
  @override
  bool kInstance(final BeizeObjectValue value) => value is BeizeExceptionValue;

  @override
  BeizeExceptionValue kInstantiate(final BeizeCallableCall call) {
    final BeizeStringValue message = call.argumentAt(0);
    final BeizeValue stackTrace = call.argumentAt(1);
    return BeizeExceptionValue(
      message.value,
      stackTrace is BeizeNullValue
          ? call.frame.getStackTrace()
          : stackTrace.kToString(),
    );
  }

  @override
  BeizeExceptionClassValue kClone() => this;

  @override
  String kToString() => '<exception class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
