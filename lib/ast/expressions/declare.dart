import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreDeclareExpression extends OutreExpression {
  const OutreDeclareExpression(this.left, this.operator, this.right)
      : super(OutreNodes.declareExpr);

  factory OutreDeclareExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreDeclareExpression(
        OutreNode.fromJson(json['left']),
        OutreNode.fromJson(json['operator']),
        OutreNode.fromJson(json['right']),
      );

  final OutreExpression left;
  final OutreToken operator;
  final OutreExpression right;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'left': left.toJson(),
        'operator': operator.toJson(),
        'right': right.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(left.span.start, right.span.end);
}
