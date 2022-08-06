import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreExpressionStatement extends OutreStatement {
  const OutreExpressionStatement(this.expression)
      : super(OutreNodes.expressionStmt);

  factory OutreExpressionStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreExpressionStatement(OutreNode.fromJson(json['expression']));

  final OutreExpression expression;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'expression': expression.toJson(),
      };
}
