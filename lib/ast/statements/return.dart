import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreReturnStatement extends OutreStatement {
  const OutreReturnStatement(this.keyword, this.expression)
      : super(OutreNodes.returnStmt);

  factory OutreReturnStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreReturnStatement(
        OutreNode.fromJson(json['keyword']),
        OutreNode.fromJsonNullable(json['expression']),
      );

  final OutreToken keyword;
  final OutreExpression? expression;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
        'expression': expression?.toJson(),
      };

  @override
  OutreSpan get span =>
      OutreSpan(keyword.span.start, expression?.span.end ?? keyword.span.end);
}
