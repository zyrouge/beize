import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'statement.dart';

class OutreContinueStatement extends OutreStatement {
  const OutreContinueStatement(this.keyword) : super(OutreNodes.continueStmt);

  factory OutreContinueStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreContinueStatement(OutreNode.fromJson(json['keyword']));

  final OutreToken keyword;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
      };

  @override
  OutreSpan get span => keyword.span;
}
