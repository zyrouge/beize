import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreWhileStatement extends OutreStatement {
  const OutreWhileStatement(this.keyword, this.condition, this.body)
      : super(OutreNodes.whileStmt);

  factory OutreWhileStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreWhileStatement(
        OutreNode.fromJson(json['keyword']),
        OutreNode.fromJson(json['condition']),
        OutreNode.fromJson(json['body']),
      );

  final OutreToken keyword;
  final OutreExpression condition;
  final OutreStatement body;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
        'condition': condition.toJson(),
        'body': body.toJson(),
      };
}
