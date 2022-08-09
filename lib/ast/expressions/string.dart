import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'literal.dart';

class OutreStringLiteralExpression extends OutreLiteralExpression<String> {
  const OutreStringLiteralExpression(final OutreToken token)
      : super(token, OutreNodes.stringExpr);

  factory OutreStringLiteralExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreStringLiteralExpression(OutreNode.fromJson(json['token']));
}
