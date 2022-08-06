import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreUnaryExpression extends OutreExpression {
  const OutreUnaryExpression(this.operator, this.right)
      : super(OutreNodes.unaryExpr);

  factory OutreUnaryExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreUnaryExpression(
        OutreNode.fromJson(json['operator']),
        OutreNode.fromJson(json['right']),
      );

  final OutreToken operator;
  final OutreExpression right;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'operator': operator.toJson(),
        'right': right.toJson(),
      };
}
