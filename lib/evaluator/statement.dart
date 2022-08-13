import '../ast/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'expression.dart';
import 'values/exports.dart';

typedef OutreStatementEvaluatorEvaluateFn = OutreValue Function(
  OutreContext context,
  OutreEnvironment environment,
  OutreStatement statement,
);

abstract class OutreStatementEvaluator {
  static final Map<OutreNodes, OutreStatementEvaluatorEvaluateFn>
      evaluateStatementFns = <OutreNodes, OutreStatementEvaluatorEvaluateFn>{
    OutreNodes.blockStmt: evaluateBlockStatement,
    OutreNodes.expressionStmt: evaluateExpressionStatement,
    OutreNodes.ifStmt: evaluateIfStatement,
    OutreNodes.returnStmt: evaluateReturnStatement,
    OutreNodes.whileStmt: evaluateWhileStatement,
    OutreNodes.breakStmt: evaluateBreakStatement,
    OutreNodes.continueStmt: evaluateContinueStatement,
  };

  static OutreValue evaluateStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    context.pushStackFrame(
      environment.createStackFrameFromOutreNode(statement),
    );
    final OutreValue result = evaluateStatementWithoutTrace(
      context,
      environment,
      statement,
    );
    context.popStackFrame();
    return result;
  }

  static OutreValue evaluateStatementWithoutTrace(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreValue result = evaluateStatementFns[statement.kind]!(
      context,
      environment,
      statement,
    );
    return result;
  }

  static OutreValue evaluateStatements(
    final OutreContext context,
    final OutreEnvironment environment,
    final List<OutreStatement> statements,
  ) {
    OutreValue value = OutreNullValue();
    for (final OutreStatement x in statements) {
      context.pushStackFrame(environment.createStackFrameFromOutreNode(x));
      value = evaluateStatementWithoutTrace(context, environment, x);
      if (value is OutreReturnValue) {
        if (environment.isInsideFunction) break;
        throw Exception('only return on function');
      }
      if (value is OutreBreakValue) {
        if (environment.isInsideLoop) break;
        throw Exception('only break on loop');
      }
      if (value is OutreContinueStatement) {
        if (environment.isInsideLoop) break;
        throw Exception('only continue on loop');
      }
      context.popStackFrame();
    }
    return value;
  }

  static OutreValue evaluateBlockStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreBlockStatement casted = statement.cast();
    return evaluateStatements(
      context,
      environment.wrap(),
      casted.statements,
    );
  }

  static OutreValue evaluateExpressionStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreExpressionStatement casted = statement.cast();
    return OutreExpressionEvaluator.evaluateExpression(
      context,
      environment,
      casted.expression,
    );
  }

  static OutreValue evaluateIfStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreIfStatement casted = statement.cast();
    final OutreBooleanValue condition =
        OutreExpressionEvaluator.evaluateExpression(
      context,
      environment,
      casted.condition,
    ).cast();
    if (condition.value) {
      return evaluateStatement(
        context,
        environment,
        casted.whenTrue,
      );
    }
    if (casted.whenFalse != null) {
      return evaluateStatement(
        context,
        environment,
        casted.whenFalse!,
      );
    }
    return OutreNullValue();
  }

  static OutreValue evaluateReturnStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreReturnStatement casted = statement.cast();
    return OutreReturnValue(
      casted.expression != null
          ? OutreExpressionEvaluator.evaluateExpression(
              context,
              environment,
              casted.expression!,
            )
          : OutreNullValue(),
    );
  }

  static OutreValue evaluateBreakStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) =>
      OutreBreakValue();

  static OutreValue evaluateContinueStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) =>
      OutreContinueValue();

  static OutreValue evaluateWhileStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreWhileStatement casted = statement.cast();
    while (true) {
      final OutreBooleanValue condition =
          OutreExpressionEvaluator.evaluateExpression(
        context,
        environment,
        casted.condition,
      ).cast();
      if (!condition.value) break;

      final OutreValue value = evaluateStatement(
        context,
        environment.wrap(
          frameName: '<${casted.keyword.type.code}>',
          isInsideLoop: true,
        ),
        casted.body,
      );
      if (value is OutreReturnValue) return value;
      if (value is OutreBreakValue) break;
    }
    return OutreNullValue();
  }
}
