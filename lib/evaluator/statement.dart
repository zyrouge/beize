import 'package:path/path.dart' as p;
import '../ast/exports.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'evaluator.dart';
import 'expression.dart';

typedef OutreStatementEvaluatorEvaluateFn = Future<OutreValue> Function(
  OutreEvaluatorContext context,
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
    OutreNodes.importStmt: evaluateImportStatement,
  };

  static Future<OutreValue> evaluateStatement(
    final OutreEvaluatorContext context,
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
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async =>
      evaluateStatementFns[statement.kind]!(
        context,
        environment,
        statement,
      );

  static Future<OutreValue> evaluateStatements(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final List<OutreStatement> statements,
  ) async {
    OutreValue value = OutreNullValue();
    for (final OutreStatement x in statements) {
      context.pushStackFrame(environment.createStackFrameFromOutreNode(x));
      value = await evaluateStatementWithoutTrace(context, environment, x);
      if (value is OutreReturnValue) {
        if (environment.isInsideFunction) break;
        throw OutreRuntimeException(
          'Cannot use "return" outside a function',
          context.stackTrace,
        );
      }
      if (value is OutreBreakValue) {
        if (environment.isInsideLoop) break;
        throw OutreRuntimeException(
          'Cannot use "break" outside a loop',
          context.stackTrace,
        );
      }
      if (value is OutreContinueValue) {
        if (environment.isInsideLoop) break;
        throw OutreRuntimeException(
          'Cannot use "continue" outside a loop',
          context.stackTrace,
        );
      }
      context.popStackFrame();
    }
    return value;
  }

  static Future<OutreValue> evaluateBlockStatement(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreBlockStatement casted = statement.cast();
    return evaluateStatements(context, environment.wrap(), casted.statements);
  }

  static Future<OutreValue> evaluateExpressionStatement(
    final OutreEvaluatorContext context,
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
    final OutreEvaluatorContext context,
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
    final OutreEvaluatorContext context,
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
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async =>
      OutreBreakValue();

  static Future<OutreValue> evaluateContinueStatement(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async =>
      OutreContinueValue();

  static Future<OutreValue> evaluateWhileStatement(
    final OutreEvaluatorContext context,
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
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreTryCatchStatement casted = statement.cast();
    try {
      await evaluateStatement(context, environment, casted.tryBlock);
    } catch (err) {
      final OutreEnvironment catchEnvironment = environment.wrap();
      final List<OutreIdentifierExpression> catchParams =
          casted.catchParams.cast();

      catchEnvironment.declareMany(<String, OutreValue>{
        if (catchParams.isNotEmpty)
          catchParams[0].value: OutreValueUtils.toOutreValue(err.toString()),
        if (catchParams.length > 1)
          catchParams[1].value: context.stackTrace.toOutreValue(),
      });

      await evaluateStatement(
        context,
        environment,
        casted.catchBlock,
      );
    }
    return OutreNullValue();
  }

  static Future<OutreValue> evaluateThrowStatement(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreThrowStatement casted = statement.cast();
    final OutreValue value = await OutreExpressionEvaluator.evaluateExpression(
      context,
      environment,
      casted.expression,
    );
    throw OutreInterropedRuntimeException(
      await OutreValueUtils.stringify(value),
      value,
      context.stackTrace,
    );
  }

  static Future<OutreValue> evaluateImportStatement(
    final OutreEvaluatorContext context,
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) async {
    final OutreImportStatement casted = statement.cast();
    final OutreStringValue pathValue = await OutreExpressionEvaluator
        .evaluateExpressionAndCast<OutreStringValue>(
      context,
      environment,
      casted.path,
    );
    final String basename = pathValue.value;
    final String path = p.join(context.rootDir, basename);
    final OutreMirroredValue value;
    if (context.hasImportCache(basename)) {
      value = context.getImportCache(basename);
    } else if (context.hasImportCache(path)) {
      value = context.getImportCache(path);
    } else {
      value = await OutreEvaluator.evaluateFile(
        path,
        frameName: '<import "$path">',
      );
      context.setImportCache(path, value);
    }
    final String name = casted.name.cast<OutreIdentifierExpression>().value;
    environment.declare(name, value);
    return OutreNullValue();
  }
}
