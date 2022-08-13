import '../utils/exports.dart';

enum OutreNodes {
  span,
  spanPoint,
  token,
  assignExpr,
  declareExpr,
  arrayExpr,
  unaryExpr,
  binaryExpr,
  callExpr,
  callExprArgs,
  functionExpr,
  functionExprParams,
  groupExpr,
  identifierExpr,
  stringExpr,
  numberExpr,
  nullExpr,
  booleanExpr,
  objectExpr,
  objectPropExpr,
  ternaryExpr,
  indexAccessExpr,
  memberAccessExpr,
  nullMemberAccessExpr,
  blockStmt,
  expressionStmt,
  ifStmt,
  returnStmt,
  whileStmt,
  breakStmt,
  continueStmt,
  tryCatchStmt,
  throwStmt,
  illegalStmt,
  module,
}

extension OutreNodesUtils on OutreNodes {
  String get stringify => OutreUtils.pascalToKebabCase(name);
  String get code => stringify.replaceFirst(RegExp('-(stmt|expr)'), '');
}

OutreNodes parseOutreNodes(final String value) => OutreUtils.findEnum(
      OutreNodes.values,
      OutreUtils.kebabToPascalCase(value),
    );
