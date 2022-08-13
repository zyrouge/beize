import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreGroupingExpression extends OutreExpression {
  const OutreGroupingExpression(this.start, this.expression, this.end)
      : super(OutreNodes.groupExpr);

  factory OutreGroupingExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreGroupingExpression(
        OutreNode.fromJson(json['start']),
        OutreNode.fromJson(json['expression']),
        OutreNode.fromJson(json['end']),
      );

  final OutreToken start;
  final OutreExpression expression;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'start': start.toJson(),
        'expression': expression.toJson(),
        'end': start.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(start.span.start, end.span.end);
}
