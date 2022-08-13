import '../ast/exports.dart';
import '../errors/runtime_exception.dart';
import '../node/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'expression.dart';
import 'statement.dart';
import 'values/exports.dart';

abstract class OutreEvaluator {
  static Future<OutreValue> evaluate(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreNode node,
  ) async {
    context.pushStackFrame(
      environment.createStackFrameFromOutreNode(node),
    );
    final OutreValue result;
    try {
      if (node is OutreModule) {
        result = await evaluateModule(context, environment, node);
      } else if (node is OutreExpression) {
        result = await OutreExpressionEvaluator.evaluateExpression(
          context,
          environment,
          node,
        );
      } else if (node is OutreStatement) {
        result = await OutreStatementEvaluator.evaluateStatement(
          context,
          environment,
          node,
        );
      } else {
        throw Exception('Unexpected node');
      }
    } catch (err, stackTrace) {
      if (err is OutreRuntimeException) {
        rethrow;
      }

      throw OutreRuntimeException(
        err.toString(),
        context.stackTrace,
        stackTrace,
      );
    }
    context.popStackFrame();
    return result;
  }

  static Future<OutreValue> evaluateModule(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreModule program,
  ) async =>
      OutreStatementEvaluator.evaluateStatements(
        context,
        environment,
        program.statements,
      );
}
