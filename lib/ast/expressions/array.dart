import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreArrayExpression extends OutreExpression {
  const OutreArrayExpression(this.start, this.elements, this.end)
      : super(OutreNodes.arrayExpr);

  factory OutreArrayExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreArrayExpression(
        OutreNode.fromJson(json['start']),
        OutreNode.fromJsonList(json['elements']),
        OutreNode.fromJson(json['end']),
      );

  final OutreToken start;
  final List<OutreExpression> elements;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'start': start.toJson(),
        'elements': OutreNode.toJsonList(elements),
        'end': end.toJson(),
      };
}
