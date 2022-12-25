import 'span.dart';
import 'tokens.dart';

class FubukiToken {
  const FubukiToken(
    this.type,
    this.literal,
    this.span, {
    this.error,
    this.errorSpan,
  });

  final FubukiTokens type;
  final dynamic literal;
  final FubukiSpan span;

  final String? error;
  final FubukiSpan? errorSpan;

  FubukiToken setLiteral(final dynamic literal) =>
      FubukiToken(type, literal, span, error: error, errorSpan: errorSpan);
}
