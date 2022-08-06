import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreBinaryExpression extends OutreExpression {
  const OutreBinaryExpression(this.left, this.operator, this.right)
      : super(OutreNodes.binaryExpr);

  factory OutreBinaryExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreBinaryExpression(
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
