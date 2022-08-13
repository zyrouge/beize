import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreThrowStatement extends OutreStatement {
  const OutreThrowStatement(this.keyword, this.expression)
      : super(OutreNodes.throwStmt);

  factory OutreThrowStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreThrowStatement(
        OutreNode.fromJson(json['keyword']),
        OutreNode.fromJson(json['expression']),
      );

  final OutreToken keyword;
  final OutreExpression expression;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
        'expression': expression.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(keyword.span.start, expression.span.end);
}
