import '../ast/exports.dart';
import '../node/exports.dart';
import 'environment.dart';
import 'expression.dart';
import 'values/exports.dart';

typedef OutreStatementEvaluatorEvaluateFn = OutreValue Function(
  OutreEnvironment context,
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
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) =>
      evaluateStatementFns[statement.kind]!(environment, statement);

  static const List<OutreValues> blockTerminatorValues = <OutreValues>[
    OutreValues.internalReturnValue,
    OutreValues.internalBreakValue,
    OutreValues.interalContinueValue,
  ];

  static OutreValue evaluateStatements(
    final OutreEnvironment environment,
    final List<OutreStatement> statements,
  ) {
    OutreValue value = OutreNullValue.value;
    for (final OutreStatement x in statements) {
      value = evaluateStatement(environment, x);
      if (blockTerminatorValues.contains(value.kind)) break;
    }
    return value;
  }

  static OutreValue evaluateBlockStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreBlockStatement casted = statement.cast();
    return evaluateStatements(OutreEnvironment(environment), casted.statements);
  }

  static OutreValue evaluateExpressionStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreExpressionStatement casted = statement.cast();
    return OutreExpressionEvaluator.evaluateExpression(
      environment,
      casted.expression,
    );
  }

  static OutreValue evaluateIfStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreIfStatement casted = statement.cast();
    final OutreBooleanValue condition =
        OutreExpressionEvaluator.evaluateExpression(
      environment,
      casted.condition,
    ).cast();
    if (condition.value) {
      return evaluateStatement(environment, casted.whenTrue);
    }
    if (casted.whenFalse != null) {
      return evaluateStatement(environment, casted.whenFalse!);
    }
    return OutreNullValue.value;
  }

  static OutreValue evaluateReturnStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreReturnStatement casted = statement.cast();
    return OutreReturnValue(
      casted.expression != null
          ? OutreExpressionEvaluator.evaluateExpression(
              environment,
              casted.expression!,
            )
          : OutreNullValue.value,
    );
  }

  static OutreValue evaluateBreakStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) =>
      OutreBreakValue();

  static OutreValue evaluateContinueStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) =>
      OutreContinueValue();

  static OutreValue evaluateWhileStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreWhileStatement casted = statement.cast();
    while (true) {
      final OutreBooleanValue condition =
          OutreExpressionEvaluator.evaluateExpression(
        environment,
        casted.condition,
      ).cast();
      if (!condition.value) break;
      final OutreValue value = evaluateStatement(environment, casted.body);
      if (value is OutreReturnValue) return value;
      if (value is OutreBreakValue) break;
    }
    return OutreNullValue.value;
  }
}
