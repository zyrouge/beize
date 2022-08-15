import '../ast/exports.dart';
import '../evaluator/exports.dart';

class OutreCustomRuntimeException extends OutreRuntimeException {
  OutreCustomRuntimeException(
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
        'Dart Stack Trace:',
        stackTrace.toString(),
      ].join('\n');
}
