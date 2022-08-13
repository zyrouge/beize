import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'statement.dart';

class OutreBlockStatement extends OutreStatement {
  const OutreBlockStatement(this.start, this.statements, this.end)
      : super(OutreNodes.blockStmt);

  factory OutreBlockStatement.fromJson(final Map<dynamic, dynamic> json) =>
      OutreBlockStatement(
        OutreNode.fromJson(json['start']),
        OutreNode.fromJsonList(json['statements']),
        OutreNode.fromJson(json['end']),
      );

  final OutreToken start;
  final List<OutreStatement> statements;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'start': start.toJson(),
        'statements': OutreNode.toJsonList(statements),
        'end': end.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(start.span.start, end.span.end);
}
