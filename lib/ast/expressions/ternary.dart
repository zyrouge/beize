import '../../lexer/exports.dart';
import '../../node/exports.dart';
import 'expression.dart';

class OutreTernaryExpression extends OutreExpression {
  const OutreTernaryExpression(this.condition, this.whenTrue, this.whenFalse)
      : super(OutreNodes.ternaryExpr);

  factory OutreTernaryExpression.fromJson(final Map<dynamic, dynamic> json) =>
      OutreTernaryExpression(
        OutreNode.fromJson(json['condition']),
        OutreNode.fromJson(json['whenTrue']),
        OutreNode.fromJson(json['whenFalse']),
      );

  final OutreExpression condition;
  final OutreExpression whenTrue;
  final OutreExpression whenFalse;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'condition': condition.toJson(),
        'whenTrue': whenFalse.toJson(),
        'whenFalse': whenFalse.toJson(),
      };

  @override
  OutreSpan get span => OutreSpan(condition.span.start, whenFalse.span.end);
}
