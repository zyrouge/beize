import '../ast/exports.dart';
import '../errors/runtime_exception.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'expression.dart';
import 'values/exports.dart';

typedef OutreStatementEvaluatorEvaluateFn = Future<OutreValue> Function(
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
    OutreNodes.tryCatchStmt: evaluateTryCatchStatement,
    OutreNodes.throwStmt: evaluateThrowStatement,
  };

  static Future<OutreValue> evaluateStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    context.pushStackFrame(
      environment.createStackFrameFromOutreNode(statement),
    );
    final OutreValue result = await evaluateStatementWithoutTrace(
      context,
      environment,
      statement,
    );
    context.popStackFrame();
    return result;
  }

  static Future<OutreValue> evaluateStatementWithoutTrace(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreValue result = await evaluateStatementFns[statement.kind]!(
      context,
      environment,
      statement,
    );
    return result;
  }

  static Future<OutreValue> evaluateStatements(
    final OutreContext context,
    final OutreEnvironment environment,
    final List<OutreStatement> statements,
  ) async {
    OutreValue value = OutreNullValue();
    for (final OutreStatement x in statements) {
      context.pushStackFrame(environment.createStackFrameFromOutreNode(x));
      value = await evaluateStatementWithoutTrace(context, environment, x);
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

  static Future<OutreValue> evaluateBlockStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreBlockStatement casted = statement.cast();
    return evaluateStatements(
      context,
      environment.wrap(),
      casted.statements,
    );
  }

  static Future<OutreValue> evaluateExpressionStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreExpressionStatement casted = statement.cast();
    return OutreExpressionEvaluator.evaluateExpression(
      context,
      environment,
      casted.expression,
    );
  }

  static Future<OutreValue> evaluateIfStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreIfStatement casted = statement.cast();
    final OutreBooleanValue condition =
        await OutreExpressionEvaluator.evaluateExpressionAndCast(
      context,
      environment,
      casted.condition,
    );
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

  static Future<OutreValue> evaluateReturnStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreReturnStatement casted = statement.cast();
    return OutreReturnValue(
      casted.expression != null
          ? await OutreExpressionEvaluator.evaluateExpression(
              context,
              environment,
              casted.expression!,
            )
          : OutreNullValue(),
    );
  }

  static Future<OutreValue> evaluateBreakStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async =>
      OutreBreakValue();

  static Future<OutreValue> evaluateContinueStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async =>
      OutreContinueValue();

  static Future<OutreValue> evaluateWhileStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreWhileStatement casted = statement.cast();
    while (true) {
      final OutreBooleanValue condition =
          await OutreExpressionEvaluator.evaluateExpressionAndCast(
        context,
        environment,
        casted.condition,
      );
      if (!condition.value) break;

      final OutreValue value = await evaluateStatement(
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

  static Future<OutreValue> evaluateTryCatchStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreTryCatchStatement casted = statement.cast();
    try {
      await evaluateStatement(context, environment, casted.tryBlock);
    } catch (err) {
      final OutreEnvironment catchEnvironment = environment.wrap();
      final List<OutreIdentifierExpression> catchParameters =
          casted.catchParameters.cast();

      catchEnvironment.declareMany(<String, OutreValue>{
        if (catchParameters.isNotEmpty)
          catchParameters[0].value:
              OutreValueUtils.toOutreValue(err.toString()),
        if (catchParameters.length > 1)
          catchParameters[1].value: context.stackTrace.toOutreValue(),
      });

      await evaluateStatement(context, environment, casted.catchBlock);
    }
    return OutreNullValue();
  }

  static Future<OutreValue> evaluateThrowStatement(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreThrowStatement casted = statement.cast();
    final OutreValue value = await OutreExpressionEvaluator.evaluateExpression(
      context,
      environment,
      casted.expression,
    );
    throw OutreCustomRuntimeException(
      await OutreValueUtils.stringify(value),
      value,
      context.stackTrace,
    );
  }
}
