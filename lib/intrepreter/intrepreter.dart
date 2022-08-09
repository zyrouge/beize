import '../ast/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'environment.dart';
import 'expression.dart';
import 'statement.dart';
import 'values/exports.dart';

abstract class OutreEvaluator {
  static OutreValue evaluate(
    final OutreEnvironment environment,
    final OutreNode node,
  ) {
    if (node is OutreModule) {
      return evaluateModule(environment, node);
    }
    if (node is OutreExpression) {
      return OutreExpressionEvaluator.evaluateExpression(environment, node);
    }
    if (node is OutreStatement) {
      return OutreStatementEvaluator.evaluateStatement(environment, node);
    }
    throw Exception('Unexpected node');
  }

  static OutreValue evaluateModule(
    final OutreEnvironment environment,
    final OutreModule program,
  ) =>
      OutreStatementEvaluator.evaluateStatements(
        environment,
        program.statements,
      );
}
