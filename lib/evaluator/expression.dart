import '../ast/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'context.dart';
import 'environment.dart';
import 'statement.dart';
import 'values/exports.dart';

typedef OutreExpressionEvaluatorEvaluateFn = OutreValue Function(
  OutreContext context,
  OutreEnvironment environment,
  OutreExpression expression,
);

typedef OutreExpressionEvaluatorCustomBinaryOperationFn = OutreValue Function(
  OutreContext context,
  OutreEnvironment environment,
  OutreBinaryExpression expression,
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
    OutreNodes.indexAccessExpr: evaluateIndexAccessExpression,
    OutreNodes.memberAccessExpr: evaluateMemberAccessExpression,
    OutreNodes.nullMemberAccessExpr: evaluateNullMemberAccessExpression,
  };

  static OutreValue evaluateExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    context.pushStackFrame(
      environment.createStackFrameFromOutreNode(expression),
    );
    final OutreValue result = evaluateExpressionFns[expression.kind]!(
      context,
      environment,
      expression,
    );
    context.popStackFrame();
    return result;
  }

  static OutreValue evaluateAssignExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreAssignExpression casted = expression.cast();
    final OutreIdentifierExpression name = casted.left.cast();
    final OutreValue value = evaluateExpression(
      context,
      environment,
      casted.right,
    );
    environment.assign(name.value, value);
    return value;
  }

  static OutreValue evaluateDeclareExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreDeclareExpression casted = expression.cast();
    final OutreIdentifierExpression name = casted.left.cast();
    final OutreValue value = evaluateExpression(
      context,
      environment,
      casted.right,
    );

    environment.declare(name.value, value);
    return value;
  }

  static OutreValue evaluateArrayExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreArrayExpression casted = expression.cast();
    return OutreArrayValue(
      casted.elements
          .map(
            (final OutreExpression x) =>
                evaluateExpression(context, environment, x),
          )
          .toList(),
    );
  }

  static OutreValue evaluateGroupExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) =>
      evaluateExpression(
        context,
        environment,
        expression.cast<OutreGroupingExpression>().expression,
      );

  static OutreValue evaluateIdentifierExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreIdentifierExpression casted = expression.cast();
    return environment.get(casted.value);
  }

  static OutreValue evaluateStringExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreStringLiteralExpression casted = expression.cast();
    return OutreStringValue(casted.value);
  }

  static OutreValue evaluateNumberExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreNumberLiteralExpression casted = expression.cast();
    return OutreNumberValue(casted.value);
  }

  static OutreValue evaluateBooleanExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreBooleanLiteralExpression casted = expression.cast();
    return OutreBooleanValue(casted.value);
  }

  static OutreValue evaluateNullExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreNullLiteralExpression _ = expression.cast();
    return OutreNullValue();
  }

  static OutreValue evaluateObjectExpression(
    final OutreContext context,
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
            evaluateExpression(context, environment, casted.key),
          ),
          evaluateExpression(context, environment, casted.value),
        );
      },
    );
    return OutreObjectValue(properties);
  }

  static OutreValue evaluateCallExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreCallExpression casted = expression.cast();
    final OutreFunctionValue callee =
        evaluateExpression(context, environment, casted.callee).cast();
    if (callee.arity != casted.arity) {
      throw Exception('Invalid amount of arguments');
    }

    final List<OutreValue> arguments = casted.arguments.arguments
        .map(
          (final OutreExpression x) =>
              evaluateExpression(context, environment, x),
        )
        .toList();
    final OutreValue value = callee.call(arguments);
    return value is OutreReturnValue ? value.value : OutreNullValue();
  }

  static OutreValue evaluateFunctionExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreFunctionExpression casted = expression.cast();
    return OutreFunctionValue(
      casted.arity,
      (final List<OutreValue> arguments) =>
          OutreStatementEvaluator.evaluateStatement(
        context,
        environment.wrap(
          frameName: '<${casted.keyword.type.code}>',
          isInsideFunction: true,
        ),
        casted.body,
      ),
    );
  }

  static OutreValue evaluateIndexAccessExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreIndexAccessExpression casted = expression.cast();
    final OutreValue left = evaluateExpression(
      context,
      environment,
      casted.left,
    ).cast();
    final OutreValue right = evaluateExpression(
      context,
      environment,
      casted.index,
    ).cast();
    return left.getPropertyOfOutreValue(right);
  }

  static OutreValue evaluateMemberAccessExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreMemberAccessExpression casted = expression.cast();
    final OutreValue left = evaluateExpression(
      context,
      environment,
      casted.left,
    ).cast();
    final OutreIdentifierExpression right = casted.right.cast();
    return left.getPropertyOfKey(right.value);
  }

  static OutreValue evaluateNullMemberAccessExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreNullMemberAccessExpression casted = expression.cast();
    final OutreValue left = evaluateExpression(
      context,
      environment,
      casted.left,
    ).cast();
    if (left is OutreNullValue) {
      return OutreNullValue();
    }

    final OutreIdentifierExpression right = casted.right.cast();
    return left.getPropertyOfKey(right.value);
  }

  static final Map<OutreValuePropertyKey, OutreValuePropertyKey>
      unaryOperationProperties = <OutreTokens, OutreValuePropertyKey>{
    OutreTokens.plus: OutreValueProperties.kUnaryPlus,
    OutreTokens.minus: OutreValueProperties.kUnaryMinus,
    OutreTokens.bang: OutreValueProperties.kUnaryNegate,
    OutreTokens.tilde: OutreValueProperties.kBitwiseInvert,
  };

  static OutreValue evaluateUnaryExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreUnaryExpression casted = expression.cast();
    return evaluateExpression(context, environment, casted.right)
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
    OutreTokens.ampersand: OutreValueProperties.kBitwiseAnd,
    OutreTokens.logicalAnd: OutreValueProperties.kLogicalAnd,
    OutreTokens.pipe: OutreValueProperties.kBitwiseOr,
    OutreTokens.logicalOr: OutreValueProperties.kLogicalOr,
    OutreTokens.caret: OutreValueProperties.kBitwiseXor,
    OutreTokens.equal: OutreValueProperties.kLogicalEqual,
    OutreTokens.notEqual: OutreValueProperties.kLogicalNotEqual,
    OutreTokens.lesserThan: OutreValueProperties.kLesserThan,
    OutreTokens.lesserThanEqual: OutreValueProperties.kLesserThanEqual,
    OutreTokens.greaterThan: OutreValueProperties.kGreaterThan,
    OutreTokens.greaterThanEqual: OutreValueProperties.kGreaterThanEqual,
  };

  static final Map<OutreTokens, OutreExpressionEvaluatorCustomBinaryOperationFn>
      binaryCustomOperations =
      <OutreTokens, OutreExpressionEvaluatorCustomBinaryOperationFn>{
    OutreTokens.nullAccess: evaluateNullAccessExpression,
    OutreTokens.nullOr: evaluateNullOrExpression,
  };

  static OutreValue evaluateBinaryExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreBinaryExpression casted = expression.cast();
    if (binaryCustomOperations.containsKey(casted.operator.type)) {
      return binaryCustomOperations[casted.operator.type]!(
        context,
        environment,
        casted,
      );
    }

    final OutreValue left = evaluateExpression(
      context,
      environment,
      casted.left,
    ).cast();
    final OutreValue right = evaluateExpression(
      context,
      environment,
      casted.right,
    ).cast();

    return left
        .getPropertyOfKey(binaryOperationProperties[casted.operator.type])
        .cast<OutreFunctionValue>()
        .call(<OutreValue>[right]);
  }

  static OutreValue evaluateNullAccessExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreBinaryExpression expression,
  ) {
    throw UnimplementedError();
  }

  static OutreValue evaluateNullOrExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreBinaryExpression expression,
  ) {
    final OutreValue left = evaluateExpression(
      context,
      environment,
      expression.left,
    ).cast();
    if (left is! OutreNullValue) {
      return left;
    }

    return evaluateExpression(
      context,
      environment,
      expression.right,
    );
  }

  static OutreValue evaluateTernaryExpression(
    final OutreContext context,
    final OutreEnvironment environment,
    final OutreExpression expression,
  ) {
    final OutreTernaryExpression casted = expression.cast();
    final OutreBooleanValue condition = evaluateExpression(
      context,
      environment,
      casted.condition,
    ).cast();

    return evaluateExpression(
      context,
      environment,
      condition.value ? casted.whenTrue : casted.whenFalse,
    );
  }
}
