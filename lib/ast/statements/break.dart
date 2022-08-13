import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'statement.dart';

class OutreBreakStatement extends OutreStatement {
  const OutreBreakStatement(this.keyword) : super(OutreNodes.breakStmt);

  factory OutreBreakStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreBreakStatement(OutreNode.fromJson(json['keyword']));

  final OutreToken keyword;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'keyword': keyword.toJson(),
      };

  @override
  OutreSpan get span => keyword.span;
}
