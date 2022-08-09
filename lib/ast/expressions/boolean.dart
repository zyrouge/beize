import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../exports.dart';
import 'literal.dart';

class OutreBooleanLiteralExpression extends OutreLiteralExpression<bool> {
  const OutreBooleanLiteralExpression(final OutreToken token)
      : super(token, OutreNodes.booleanExpr);

  factory OutreBooleanLiteralExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreBooleanLiteralExpression(OutreNode.fromJson(json['token']));
}
