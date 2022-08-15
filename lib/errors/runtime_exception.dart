import '../ast/exports.dart';
import '../evaluator/exports.dart';

class OutreUntracedRuntimeException extends Error {
  OutreUntracedRuntimeException(this.message);

  final String message;
}

class OutreInterropedRuntimeException extends OutreRuntimeException {
  OutreInterropedRuntimeException(
    super.message,
    this.value,
    super.outreStackTrace, [
    super.stackTrace,
  ]) {
    toOutreValueProperties().forEach((
      final OutreValuePropertyKey key,
      final OutreValue value,
    ) {
      value.setPropertyOfKey(key, value);
    });
  }

  final OutreValue value;

  @override
  OutreValue toOutreValue() => value;
}

class OutreRuntimeException extends Error with OutreConvertableValue {
  OutreRuntimeException(this.message, this.outreStackTrace, [this.stackTrace]);

  final String message;
  @override
  final StackTrace? stackTrace;
  final OutreStackTrace outreStackTrace;

  Map<OutreValuePropertyKey, OutreValue> toOutreValueProperties() =>
      <OutreValuePropertyKey, OutreValue>{
        'message': OutreStringValue(message),
        'stackTrace': outreStackTrace.toOutreValue(),
      };

  @override
  OutreValue toOutreValue() => OutreObjectValue(toOutreValueProperties());

  @override
  String toString() => <String>[
        'OutreRuntimeException: $message',
        'Outre Stack Trace:',
        outreStackTrace.toString(),
        if (stackTrace != null) ...<String>[
          'Dart Stack Trace:',
          stackTrace.toString(),
        ],
      ].join('\n');
}
