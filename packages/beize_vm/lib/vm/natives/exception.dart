import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeExceptionNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('new'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue message = call.argumentAt(0);
          final BeizeValue stackTrace = call.argumentAt(1);
          return BeizeExceptionValue(
            message.value,
            stackTrace is BeizeNullValue
                ? call.frame.getStackTrace()
                : stackTrace.kToString(),
          );
        },
      ),
    );
    namespace.declare('Exception', value);
  }
}
