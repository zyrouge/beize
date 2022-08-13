import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreObjectExpression extends OutreExpression {
  const OutreObjectExpression(
    this.keyword,
    this.start,
    this.properties,
    this.end,
  ) : super(OutreNodes.objectExpr);

  factory OutreObjectExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreObjectExpression(
        OutreNode.fromJson(json['keyword']),
        OutreNode.fromJson(json['start']),
        OutreNode.fromJsonList(json['properties']),
        OutreNode.fromJson(json['end']),
      );

  final OutreToken keyword;
  final OutreToken start;
  final List<OutreObjectExpressionProperty> properties;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
        'start': start.toJson(),
        'properties': OutreNode.toJsonList(properties),
        'end': end.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(keyword.span.start, end.span.end);
}

class OutreObjectExpressionProperty extends OutreExpression {
  const OutreObjectExpressionProperty(this.key, this.operator, this.value)
      : super(OutreNodes.objectPropExpr);

  factory OutreObjectExpressionProperty.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreObjectExpressionProperty(
        OutreNode.fromJson(json['key']),
        OutreNode.fromJson(json['operator']),
        OutreNode.fromJson(json['value']),
      );

  final OutreExpression key;
  final OutreToken operator;
  final OutreExpression value;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'key': key.toJson(),
        'operator': operator.toJson(),
        'value': value.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(key.span.start, value.span.end);
}
