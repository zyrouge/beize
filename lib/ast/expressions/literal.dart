import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreLiteralExpression extends OutreExpression {
  const OutreLiteralExpression(this.token) : super(OutreNodes.literalExpr);

  factory OutreLiteralExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreLiteralExpression(OutreNode.fromJson(json['token']));

  final OutreToken token;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'token': token.toJson(),
      };
}
