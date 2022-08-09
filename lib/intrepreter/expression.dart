import '../ast/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'environment.dart';
import 'statement.dart';
import 'values/exports.dart';

typedef OutreExpressionEvaluatorEvaluateFn = OutreValue Function(
  OutreEnvironment context,
  OutreExpression expression,
);

abstract class OutreExpressionEvaluator {
  static final Map<OutreNodes, OutreExpressionEvaluatorEvaluateFn>
      evaluateExpressionFns = <OutreNodes, OutreExpressionEvaluatorEvaluateFn>{
    OutreNodes.assignExpr: evaluateAssignExpression,
    OutreNodes.declareExpr: evaluateDeclareExpression,
    OutreNodes.arrayExpr: evaluateArrayExpression,
    OutreNodes.callExpr: evaluateCallExpression,
    OutreNodes.functionExpr: evaluateFunctionExpression,
    OutreNodes.groupExpr: evaluateGroupExpression,
    OutreNodes.identifierExpr: evaluateIdentifierExpression,
    OutreNodes.stringExpr: evaluateStringExpression,
    OutreNodes.numberExpr: evaluateNumberExpression,
    OutreNodes.booleanExpr: evaluateBooleanExpression,
    OutreNodes.nullExpr: evaluateNullExpression,
    OutreNodes.objectExpr: evaluateObjectExpression,
    OutreNodes.unaryExpr: evaluateUnaryExpression,
    OutreNodes.binaryExpr: evaluateBinaryExpression,
    OutreNodes.ternaryExpr: evaluateTernaryExpression,
  };

  static OutreValue evaluateExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) =>
      evaluateExpressionFns[expression.kind]!(environment, expression);

  static OutreValue evaluateAssignExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreAssignExpression casted = expression.cast();
    final OutreIdentifierExpression name = casted.left.cast();
    final OutreValue value = evaluateExpression(environment, casted.right);
    environment.assign(name.value, value);
    return value;
  }

  static OutreValue evaluateDeclareExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreDeclareExpression casted = expression.cast();
    final OutreIdentifierExpression name = casted.left.cast();
    final OutreValue value = evaluateExpression(environment, casted.right);
    environment.declare(name.value, value);
    return value;
  }

  static OutreValue evaluateArrayExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreDeclareExpression casted = expression.cast();
    final OutreIdentifierExpression name = casted.left.cast();
    final OutreValue value = evaluateExpression(environment, casted.right);
    environment.declare(name.value, value);
    return value;
  }

  static OutreValue evaluateGroupExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) =>
      evaluateExpression(
        environment,
        expression.cast<OutreGroupingExpression>().expression,
      );

  static OutreValue evaluateIdentifierExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreIdentifierExpression casted = expression.cast();
    return environment.get(casted.value);
  }

  static OutreValue evaluateStringExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreStringLiteralExpression casted = expression.cast();
    return OutreStringValue(casted.value);
  }

  static OutreValue evaluateNumberExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreNumberLiteralExpression casted = expression.cast();
    return OutreNumberValue(casted.value);
  }

  static OutreValue evaluateBooleanExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreBooleanLiteralExpression casted = expression.cast();
    return OutreBooleanValue(casted.value);
  }

  static OutreValue evaluateNullExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreNullLiteralExpression _ = expression.cast();
    return OutreNullValue.value;
  }

  static OutreValue evaluateObjectExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreObjectExpression casted = expression.cast();
    final Map<OutreValuePropertyKey, OutreValue> properties =
        casted.properties.asMap().map(
      (final int i, final OutreExpression x) {
        final OutreObjectExpressionProperty casted = x.cast();
        return MapEntry<OutreValuePropertyKey, OutreValue>(
          OutreValue.getKeyFromOutreValue(
            evaluateExpression(environment, casted.key),
          ),
          evaluateExpression(environment, casted.value),
        );
      },
    );
    return OutreObjectValue(properties);
  }

  static OutreValue evaluateCallExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreCallExpression casted = expression.cast();
    final OutreFunctionValue callee =
        evaluateExpression(environment, casted.callee).cast();
    if (callee.arity != casted.arity) {
      throw Exception('Invalid amount of arguments');
    }

    final List<OutreValue> arguments = casted.arguments.arguments
        .map((final OutreExpression x) => evaluateExpression(environment, x))
        .toList();
    return callee.call(arguments);
  }

  static OutreValue evaluateFunctionExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreFunctionExpression casted = expression.cast();
    return OutreFunctionValue(
      casted.arity,
      (final List<OutreValue> arguments) =>
          OutreStatementEvaluator.evaluateStatement(
        environment,
        casted.body,
      ),
    ).cast<OutreFunctionValue>().call(<OutreValue>[]);
  }

  static final Map<OutreValuePropertyKey, OutreValuePropertyKey>
      unaryOperationProperties = <OutreTokens, OutreValuePropertyKey>{
    OutreTokens.plus: OutreValueProperties.kUnaryPlus,
    OutreTokens.minus: OutreValueProperties.kUnaryMinus,
    OutreTokens.bang: OutreValueProperties.kUnaryNegate,
  };

  static OutreValue evaluateUnaryExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreUnaryExpression casted = expression.cast();
    return evaluateExpression(environment, casted.right)
        .cast<OutreValue>()
        .getPropertyOfKey(unaryOperationProperties[casted.operator.type])
        .cast<OutreFunctionValue>()
        .call(<OutreValue>[]);
  }

  static final Map<OutreTokens, OutreValuePropertyKey>
      binaryOperationProperties = <OutreTokens, OutreValuePropertyKey>{
    OutreTokens.plus: OutreValueProperties.kAdd,
    OutreTokens.minus: OutreValueProperties.kSubtract,
    OutreTokens.asterisk: OutreValueProperties.kMultiply,
    OutreTokens.exponent: OutreValueProperties.kPow,
    OutreTokens.slash: OutreValueProperties.kDivide,
    OutreTokens.floor: OutreValueProperties.kFloorDivide,
    OutreTokens.modulo: OutreValueProperties.kModulo,
  };

  static OutreValue evaluateBinaryExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreBinaryExpression casted = expression.cast();
    final OutreValue left = evaluateExpression(environment, casted.left).cast();
    final OutreValue right =
        evaluateExpression(environment, casted.right).cast();
    return left
        .getPropertyOfKey(binaryOperationProperties[casted.operator.type])
        .cast<OutreFunctionValue>()
        .call(<OutreValue>[right]);
  }

  static OutreValue evaluateTernaryExpression(
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreTernaryExpression casted = expression.cast();
    final OutreBooleanValue condition =
        evaluateExpression(environment, casted.condition).cast();
    return evaluateExpression(
      environment,
      condition.value ? casted.whenTrue : casted.whenFalse,
    );
  }

  static OutreValue evaluateStatements(
    final OutreEnvironment environment,
    final List<OutreStatement> statements,
  ) {
    OutreValue value = OutreNullValue.value;
    for (final OutreStatement x in statements) {
      value = OutreStatementEvaluator.evaluateStatement(
        environment,
        x,
      );
      if (x is OutreReturnStatement) break;
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
    return evaluateExpression(environment, casted.expression);
  }

  static OutreValue evaluateIfStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreIfStatement casted = statement.cast();
    final OutreBooleanValue condition =
        evaluateExpression(environment, casted.condition).cast();
    if (condition.value) {
      return OutreStatementEvaluator.evaluateStatement(
        environment,
        casted.whenTrue,
      );
    }
    if (casted.whenFalse != null) {
      return OutreStatementEvaluator.evaluateStatement(
        environment,
        casted.whenFalse!,
      );
    }
    return OutreNullValue.value;
  }

  static OutreValue evaluateReturnStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreReturnStatement casted = statement.cast();
    if (casted.expression == null) return OutreNullValue.value;
    return evaluateExpression(environment, casted.expression!);
  }

  static OutreValue evaluateWhileStatement(
    final OutreEnvironment environment,
    final OutreStatement statement,
  ) {
    final OutreWhileStatement casted = statement.cast();
    while (true) {
      final OutreBooleanValue condition =
          evaluateExpression(environment, casted.condition).cast();
      if (!condition.value) break;
      OutreStatementEvaluator.evaluateStatement(
        environment,
        casted.body,
      );
    }
    return OutreNullValue.value;
  }
}
