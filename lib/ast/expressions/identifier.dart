import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreIdentifierExpression extends OutreExpression {
  const OutreIdentifierExpression(this.name) : super(OutreNodes.identifierExpr);

  factory OutreIdentifierExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreIdentifierExpression(OutreNode.fromJson(json['name']));

  final OutreToken name;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'name': name.toJson(),
      };
}
