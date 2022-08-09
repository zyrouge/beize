import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'literal.dart';

class OutreNumberLiteralExpression extends OutreLiteralExpression<double> {
  const OutreNumberLiteralExpression(final OutreToken token)
      : super(token, OutreNodes.numberExpr);

  factory OutreNumberLiteralExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreNumberLiteralExpression(OutreNode.fromJson(json['token']));
}
