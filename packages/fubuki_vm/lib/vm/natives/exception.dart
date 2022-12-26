import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiExceptionNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('new'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue message = call.argumentAt(0);
          final FubukiValue stackTrace = call.argumentAt(1);
          if (stackTrace is FubukiNullValue) {
            return newException(
              message,
              FubukiStringValue(call.vm.getCurrentStackTrace()),
            );
          }
          return newException(message, stackTrace.cast());
        },
      ),
    );
    namespace.declare('Exception', value);
  }

  static FubukiValue newExceptionNative(
    final String message,
    final String stackTrace,
  ) =>
      newException(
        FubukiStringValue(message),
        FubukiStringValue(stackTrace),
        prefix: false,
      );

  static FubukiValue newException(
    final FubukiStringValue message,
    final FubukiStringValue stackTrace, {
    final bool prefix = true,
  }) {
    final FubukiStringValue value = FubukiStringValue(
      (StringBuffer()
            ..writeln(prefix ? 'Exception: ${message.value}' : message.value)
            ..writeln('Stack Trace:')
            ..write(stackTrace.value))
          .toString(),
    );
    value.set(FubukiStringValue('message'), message);
    value.set(FubukiStringValue('stackTrace'), stackTrace);
    return value;
  }
}
