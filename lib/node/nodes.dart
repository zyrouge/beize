import '../utils/exports.dart';

enum OutreNodes {
  span,
  spanPoint,
  token,
  arrayExpr,
  binaryExpr,
  callExpr,
  callExprArgs,
  functionExpr,
  functionExprParams,
  groupExpr,
  identifierExpr,
  literalExpr,
  ternaryExpr,
  unaryExpr,
  blockStmt,
  expressionStmt,
  ifStmt,
  returnStmt,
  whileStmt,
  breakStmt,
  continueStmt,
  illegalStmt,
  module,
}

extension OutreNodesUtils on OutreNodes {
  String get stringify => OutreUtils.pascalToKebabCase(name);
}

OutreNodes parseOutreNodes(final String value) => OutreUtils.findEnum(
      OutreNodes.values,
      OutreUtils.kebabToPascalCase(value),
    );
