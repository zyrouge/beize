import 'span.dart';
import 'tokens.dart';

class BaizeToken {
  const BaizeToken(
    this.type,
    this.literal,
    this.span, {
    this.error,
    this.errorSpan,
  });

  final BaizeTokens type;
  final dynamic literal;
  final BaizeSpan span;

  final String? error;
  final BaizeSpan? errorSpan;

  BaizeToken setLiteral(final dynamic literal) =>
      BaizeToken(type, literal, span, error: error, errorSpan: errorSpan);
}
