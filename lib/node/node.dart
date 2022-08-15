import 'package:meta/meta.dart';
import '../ast/exports.dart';
import '../lexer/exports.dart';
import '../utils/exports.dart';
import 'nodes.dart';

typedef OutreNodeFromJsonFn = OutreNode Function(Map<dynamic, dynamic> json);

abstract class OutreNode {
  const OutreNode(this.kind);

  final OutreNodes kind;

  T cast<T extends OutreNode>() => this as T;

  @mustCallSuper
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'kind': kind.stringify,
      };

  OutreSpan get span;

  static const Map<OutreNodes, OutreNodeFromJsonFn> fromJsonFns =
      <OutreNodes, OutreNodeFromJsonFn>{
    OutreNodes.span: OutreSpan.fromJson,
    OutreNodes.spanPoint: OutreSpanPoint.fromJson,
    OutreNodes.token: OutreToken.fromJson,
    OutreNodes.arrayExpr: OutreArrayExpression.fromJson,
    OutreNodes.assignExpr: OutreAssignExpression.fromJson,
    OutreNodes.declareExpr: OutreDeclareExpression.fromJson,
    OutreNodes.binaryExpr: OutreBinaryExpression.fromJson,
    OutreNodes.callExpr: OutreCallExpression.fromJson,
    OutreNodes.callExprArgs: OutreCallExpressionArguments.fromJson,
    OutreNodes.functionExpr: OutreFunctionExpression.fromJson,
    OutreNodes.functionExprParams: OutreFunctionExpressionParameters.fromJson,
    OutreNodes.groupExpr: OutreGroupingExpression.fromJson,
    OutreNodes.identifierExpr: OutreIdentifierExpression.fromJson,
    OutreNodes.stringExpr: OutreStringLiteralExpression.fromJson,
    OutreNodes.booleanExpr: OutreBooleanLiteralExpression.fromJson,
    OutreNodes.numberExpr: OutreNumberLiteralExpression.fromJson,
    OutreNodes.nullExpr: OutreNullLiteralExpression.fromJson,
    OutreNodes.objectExpr: OutreObjectExpression.fromJson,
    OutreNodes.objectPropExpr: OutreObjectExpressionProperty.fromJson,
    OutreNodes.ternaryExpr: OutreTernaryExpression.fromJson,
    OutreNodes.unaryExpr: OutreUnaryExpression.fromJson,
    OutreNodes.indexAccessExpr: OutreIndexAccessExpression.fromJson,
    OutreNodes.memberAccessExpr: OutreMemberAccessExpression.fromJson,
    OutreNodes.nullMemberAccessExpr: OutreNullMemberAccessExpression.fromJson,
    OutreNodes.blockStmt: OutreBlockStatement.fromJson,
    OutreNodes.expressionStmt: OutreExpressionStatement.fromJson,
    OutreNodes.ifStmt: OutreIfStatement.fromJson,
    OutreNodes.returnStmt: OutreReturnStatement.fromJson,
    OutreNodes.whileStmt: OutreWhileStatement.fromJson,
    OutreNodes.breakStmt: OutreBreakStatement.fromJson,
    OutreNodes.continueStmt: OutreContinueStatement.fromJson,
    OutreNodes.tryCatchStmt: OutreTryCatchStatement.fromJson,
    OutreNodes.throwStmt: OutreThrowStatement.fromJson,
    OutreNodes.importStmt: OutreImportStatement.fromJson,
    OutreNodes.module: OutreModule.fromJson,
  };

  static T fromJson<T extends OutreNode>(final dynamic json) {
    final Map<dynamic, dynamic> casted = json as Map<dynamic, dynamic>;
    final OutreNodes type = OutreUtils.findEnum(
      OutreNodes.values,
      OutreUtils.kebabToPascalCase(casted['kind'] as String),
    );
    return fromJsonFns[type]!(casted) as T;
  }

  static T? fromJsonNullable<T extends OutreNode>(final dynamic json) =>
      json != null ? fromJson(json) : null;

  static List<T> fromJsonList<T extends OutreNode>(final dynamic json) =>
      (json as List<dynamic>)
          .cast<Map<dynamic, dynamic>>()
          .map((final Map<dynamic, dynamic> x) => OutreNode.fromJson<T>(x))
          .toList();

  static List<Map<dynamic, dynamic>> toJsonList<T extends OutreNode>(
    final List<T> elements,
  ) =>
      elements.map((final T x) => x.toJson()).toList();
}
