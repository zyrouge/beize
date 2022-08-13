import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreCallExpression extends OutreExpression {
  const OutreCallExpression(this.callee, this.arguments)
      : super(OutreNodes.callExpr);

  factory OutreCallExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreCallExpression(
        OutreNode.fromJson(json['callee']),
        OutreNode.fromJson(json['arguments']),
      );

  final OutreExpression callee;
  final OutreCallExpressionArguments arguments;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'callee': callee.toJson(),
        'arguments': arguments.toJson(),
      };

  int get arity => arguments.arguments.length;

  @override
  OutreSpan get span => OutreSpan(callee.span.start, arguments.span.end);
}

class OutreCallExpressionArguments extends OutreNode {
  const OutreCallExpressionArguments(this.start, this.arguments, this.end)
      : super(OutreNodes.callExprArgs);

  factory OutreCallExpressionArguments.fromJson(
    final Map<dynamic, dynamic> json,
  ) =>
      OutreCallExpressionArguments(
        OutreNode.fromJson(json['start']),
        OutreNode.fromJsonList(json['arguments']),
        OutreNode.fromJson(json['end']),
      );

  final OutreToken start;
  final List<OutreExpression> arguments;
  final OutreToken end;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'start': start.toJson(),
        'arguments': OutreNode.toJsonList(arguments),
        'end': end.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(start.span.start, end.span.end);
}
