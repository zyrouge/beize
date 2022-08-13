import '../evaluator/exports.dart';

class OutreRuntimeException extends Error {
  OutreRuntimeException(this.text, this.outreStackTrace, [this.stackTrace]);

  final String text;
  @override
  final StackTrace? stackTrace;
  final OutreStackTrace outreStackTrace;

  @override
  String toString() => <String>[
        'OutreRuntimeException: $text',
        'Outre Stack Trace:',
        outreStackTrace.toString(),
        'Dart Stack Trace:',
        stackTrace.toString(),
      ].join('\n');
}
