import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'literal.dart';

class OutreNullLiteralExpression extends OutreLiteralExpression<void> {
  const OutreNullLiteralExpression(final OutreToken token)
      : super(token, OutreNodes.nullExpr);

  factory OutreNullLiteralExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreNullLiteralExpression(OutreNode.fromJson(json['token']));
}
