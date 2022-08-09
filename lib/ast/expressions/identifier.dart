import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'literal.dart';

class OutreIdentifierExpression extends OutreLiteralExpression<String> {
  const OutreIdentifierExpression(final OutreToken token)
      : super(token, OutreNodes.identifierExpr);

  factory OutreIdentifierExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreIdentifierExpression(OutreNode.fromJson(json['name']));
}
