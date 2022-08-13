import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'statements/exports.dart';

class OutreModule extends OutreNode {
  OutreModule({
    required this.statements,
    required this.errors,
  }) : super(OutreNodes.module);

  factory OutreModule.fromJson(final Map<dynamic, dynamic> json) => OutreModule(
        statements: OutreNode.fromJsonList(json['statements']),
        errors: (json['errors'] as List<dynamic>)
            .map((final dynamic x) => OutreIllegalExpressionError(x as String))
            .toList(),
      );

  final List<OutreStatement> statements;
  final List<OutreIllegalExpressionError> errors;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'statements': OutreNode.toJsonList(statements),
        'errors': errors
            .map((final OutreIllegalExpressionError err) => err.text)
            .toList(),
      };

  bool get hasErrors => errors.isNotEmpty;

  @override
  OutreSpan get span {
    const OutreSpanPoint start = OutreSpanPoint();
    return OutreSpan(
      start,
      statements.isNotEmpty ? statements.last.span.end : start,
    );
  }
}
