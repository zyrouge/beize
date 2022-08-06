import '../utils.dart';

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
  unaryExpr,
  program,
  blockStmt,
  expressionStmt,
  ifStmt,
  returnStmt,
  whileStmt,
  breakStmt,
  continueStmt,
}

extension OutreNodesUtils on OutreNodes {
  String get stringify => OutreUtils.pascalToKebabCase(name);
}

OutreNodes parseOutreNodes(final String value) => OutreUtils.findEnum(
      OutreNodes.values,
      OutreUtils.kebabToPascalCase(value),
    );
