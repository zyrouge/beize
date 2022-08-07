import '../../node/exports.dart';
import '../span.dart';
import 'tokens.dart';

class OutreToken extends OutreNode {
  const OutreToken(
    this.type,
    this.literal,
    this.span, {
    this.error,
    this.errorSpan,
  }) : super(OutreNodes.token);

  factory OutreToken.fromJson(final Map<dynamic, dynamic> json) => OutreToken(
        parseOutreTokens(json['type'] as String),
        json['literal'],
        OutreNode.fromJson(json['span']),
        error: json['error'] as String?,
        errorSpan: OutreNode.fromJsonNullable(json['errorSpan']),
      );

  final OutreTokens type;
  final dynamic literal;
  final OutreSpan span;

  final String? error;
  final OutreSpan? errorSpan;

  OutreToken setLiteral(final dynamic literal) =>
      OutreToken(type, literal, span, error: error, errorSpan: errorSpan);

  OutreToken copyWith({
    final OutreTokens? type,
    final dynamic literal,
    final OutreSpan? span,
    final String? error,
    final OutreSpan? errorSpan,
  }) =>
      OutreToken(
        type ?? this.type,
        literal ?? this.literal,
        span ?? this.span,
        error: error ?? this.error,
        errorSpan: errorSpan ?? this.errorSpan,
      );

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'type': type.stringify,
        'literal': literal,
        'span': span.toJson(),
        'error': error,
        'errorSpan': errorSpan?.toJson(),
      };

  @override
  String toString() =>
      'OutreToken($type, $literal, ${span.toPositionString()}, $error, ${errorSpan?.toPositionString()})';
}
