import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeExceptionNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('new'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue message = call.argumentAt(0);
          final BaizeValue stackTrace = call.argumentAt(1);
          if (stackTrace is BaizeNullValue) {
            return newException(
              message,
              BaizeStringValue(call.frame.getStackTrace()),
            );
          }
          return newException(message, stackTrace.cast());
        },
      ),
    );
    namespace.declare('Exception', value);
  }

  static BaizeValue newExceptionNative(
    final String message,
    final String stackTrace,
  ) =>
      newException(
        BaizeStringValue(message),
        BaizeStringValue(stackTrace),
        prefix: false,
      );

  static BaizeValue newException(
    final BaizeStringValue message,
    final BaizeStringValue stackTrace, {
    final bool prefix = true,
  }) {
    final BaizeStringValue value = BaizeStringValue(
      (StringBuffer()
            ..writeln(prefix ? 'Exception: ${message.value}' : message.value)
            ..writeln('Stack Trace:')
            ..write(stackTrace.value))
          .toString(),
    );
    value.set(BaizeStringValue('message'), message);
    value.set(BaizeStringValue('stackTrace'), stackTrace);
    return value;
  }
}
