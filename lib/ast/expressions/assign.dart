import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreAssignExpression extends OutreExpression {
  const OutreAssignExpression(this.left, this.operator, this.right)
      : super(OutreNodes.assignExpr);

  factory OutreAssignExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreAssignExpression(
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
}
