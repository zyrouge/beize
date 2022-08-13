import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreIndexAccessExpression extends OutreExpression {
  const OutreIndexAccessExpression(
    this.left,
    this.start,
    this.index,
    this.end,
  ) : super(OutreNodes.indexAccessExpr);

  factory OutreIndexAccessExpression.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreIndexAccessExpression(
        OutreNode.fromJson(json['left']),
        OutreNode.fromJson(json['start']),
        OutreNode.fromJson(json['index']),
        OutreNode.fromJson(json['end']),
      );

  final OutreExpression left;
  final OutreToken start;
  final OutreExpression index;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'left': left.toJson(),
        'start': start.toJson(),
        'index': index.toJson(),
        'end': end.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(left.span.start, end.span.end);
}
