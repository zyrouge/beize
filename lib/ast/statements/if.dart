import '../../lexer/exports.dart';
import '../../node/exports.dart';
import '../expressions/exports.dart';
import 'statement.dart';

class OutreIfStatement extends OutreStatement {
  const OutreIfStatement(
    this.keyword,
    this.condition,
    this.whenTrue, [
    this.whenFalse,
  ]) : super(OutreNodes.ifStmt);

  factory OutreIfStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreIfStatement(
        OutreNode.fromJson(json['keyword']),
        OutreNode.fromJson(json['condition']),
        OutreNode.fromJson(json['whenTrue']),
        OutreNode.fromJsonNullable(json['whenFalse']),
      );

  final OutreToken keyword;
  final OutreExpression condition;
  final OutreStatement whenTrue;
  final OutreStatement? whenFalse;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
        'condition': condition.toJson(),
        'whenTrue': whenTrue.toJson(),
        'whenFalse': whenFalse?.toJson(),
      };
}
