import '../lexer/exports.dart';

class OutreIllegalExpressionError extends Error {
  OutreIllegalExpressionError(this.text);

  factory OutreIllegalExpressionError.illegalToken(final OutreToken token) =>
      OutreIllegalExpressionError(
        <String>[
          'Illegal token "${token.type.code}" found at ${token.span.toPositionString()}',
          if (token.error != null)
            '(${token.error}${token.errorSpan != null ? ' at ${token.errorSpan!.toPositionString()}' : ''})',
        ].join(' '),
      );

  factory OutreIllegalExpressionError.expectedXButReceivedX(
    final String expected,
    final String received,
    final String position,
  ) =>
      OutreIllegalExpressionError(
        'Expected "$expected" but found "$received" at $position',
      );

  factory OutreIllegalExpressionError.expectedXButReceivedToken(
    final String expected,
    final OutreTokens received,
    final OutreSpan span,
  ) =>
      OutreIllegalExpressionError.expectedXButReceivedX(
        expected,
        received.code,
        span.toPositionString(),
      );

  factory OutreIllegalExpressionError.expectedTokenButReceivedToken(
    final OutreTokens expected,
    final OutreTokens received,
    final OutreSpan span,
  ) =>
      OutreIllegalExpressionError.expectedXButReceivedX(
        expected.code,
        received.code,
        span.toPositionString(),
      );

  final String text;

  @override
  String toString() => 'IllegalExpressionError: $text';
}
