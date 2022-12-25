import '../token/exports.dart';

class FubukiIllegalExpressionError extends Error {
  FubukiIllegalExpressionError(this.text);

  factory FubukiIllegalExpressionError.illegalToken(final FubukiToken token) =>
      FubukiIllegalExpressionError(
        <String>[
          'Illegal token "${token.type.code}" found at ${token.span}',
          if (token.error != null)
            '(${token.error}${token.errorSpan != null ? ' at ${token.errorSpan}' : ''})',
        ].join(' '),
      );

  factory FubukiIllegalExpressionError.expectedXButReceivedX(
    final String expected,
    final String received,
    final String position,
  ) =>
      FubukiIllegalExpressionError(
        'Expected "$expected" but found "$received" at $position',
      );

  factory FubukiIllegalExpressionError.expectedXButReceivedToken(
    final String expected,
    final FubukiTokens received,
    final FubukiSpan span,
  ) =>
      FubukiIllegalExpressionError.expectedXButReceivedX(
        expected,
        received.code,
        span.toString(),
      );

  factory FubukiIllegalExpressionError.expectedTokenButReceivedToken(
    final FubukiTokens expected,
    final FubukiTokens received,
    final FubukiSpan span,
  ) =>
      FubukiIllegalExpressionError.expectedXButReceivedX(
        expected.code,
        received.code,
        span.toString(),
      );

  factory FubukiIllegalExpressionError.cannotReturnInsideScript(
    final FubukiToken token,
  ) =>
      FubukiIllegalExpressionError(
        'Cannot return inside script ("${token.type.code}" found at ${token.span})',
      );

  final String text;

  @override
  String toString() => 'FubukiIllegalExpressionError: $text';
}
