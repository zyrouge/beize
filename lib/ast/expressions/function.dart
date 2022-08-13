import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../statements/exports.dart';
import 'expression.dart';

class OutreFunctionExpression extends OutreExpression {
  const OutreFunctionExpression(this.keyword, this.parameters, this.body)
      : super(OutreNodes.functionExpr);

  factory OutreFunctionExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreFunctionExpression(
        OutreNode.fromJson(json['keyword']),
        OutreNode.fromJsonNullable(json['parameters']),
        OutreNode.fromJson(json['body']),
      );

  final OutreToken keyword;
  final OutreFunctionExpressionParameters? parameters;
  final OutreStatement body;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
        'parameters': parameters?.toJson(),
        'body': body.toJson(),
      };

  bool get hasParameters => parameters != null;

  @override
  OutreSpan get span => OutreSpan(keyword.span.start, body.span.end);
}

class OutreFunctionExpressionParameters extends OutreNode {
  const OutreFunctionExpressionParameters(
    this.start,
    this.parameters,
    this.end,
  ) : super(OutreNodes.functionExprParams);

  factory OutreFunctionExpressionParameters.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreFunctionExpressionParameters(
        OutreNode.fromJson(json['start']),
        OutreNode.fromJsonList(json['parameters']),
        OutreNode.fromJson(json['end']),
      );

  final OutreToken start;
  final List<OutreExpression> parameters;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'start': start.toJson(),
        'parameters': OutreNode.toJsonList(parameters),
        'end': end.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(start.span.start, end.span.end);
}
