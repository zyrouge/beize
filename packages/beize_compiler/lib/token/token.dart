import 'span.dart';
import 'tokens.dart';

class BeizeToken {
  const BeizeToken(
    this.type,
    this.literal,
    this.span, {
    this.error,
    this.errorSpan,
  });

  final BeizeTokens type;
  final dynamic literal;
  final BeizeSpan span;

  final String? error;
  final BeizeSpan? errorSpan;

  BeizeToken setLiteral(final dynamic literal) =>
      BeizeToken(type, literal, span, error: error, errorSpan: errorSpan);
}
