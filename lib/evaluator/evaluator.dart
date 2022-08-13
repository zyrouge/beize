import '../ast/exports.dart';
import '../errors/runtime_exception.dart';
import '../node/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'expression.dart';
import 'statement.dart';
import 'values/exports.dart';

abstract class OutreEvaluator {
  static OutreValue evaluate(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreNode node,
  ) {
    context.pushStackFrame(
      environment.createStackFrameFromOutreNode(node),
    );
    final OutreValue result;
    try {
      if (node is OutreModule) {
        result = evaluateModule(context, environment, node);
      } else if (node is OutreExpression) {
        result = OutreExpressionEvaluator.evaluateExpression(
          context,
          environment,
          node,
        );
      } else if (node is OutreStatement) {
        result = OutreStatementEvaluator.evaluateStatement(
          context,
          environment,
          node,
        );
      } else {
        throw Exception('Unexpected node');
      }
    } catch (err, stackTrace) {
      throw OutreRuntimeException(
        err.toString(),
        context.stackTrace,
        stackTrace,
      );
    }
    context.popStackFrame();
    return result;
  }

  static OutreValue evaluateModule(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreModule program,
  ) =>
      OutreStatementEvaluator.evaluateStatements(
        context,
        environment,
        program.statements,
      );
}
