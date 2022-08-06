import '../lexer/exports.dart';

class OutreIllegalExpressionError extends Error {
  OutreIllegalExpressionError(this.text, this.span);

  final String text;
  final OutreSpan span;

  @override
  String toString() =>
      'IllegalExpressionError: $text at ${span.toPositionString()}';
}
