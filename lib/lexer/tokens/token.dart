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
  String toString() => 'OutreToken(${<String>[
        type.name,
        literal.toString(),
        span.toPositionString(),
        if (error != null)
          '$error at ${(errorSpan ?? span).toPositionString()}',
      ].map((final String x) => '"$x"').join(', ')})';
}
