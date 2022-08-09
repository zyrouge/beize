import '../../lexer/exports.dart';
import 'expression.dart';

abstract class OutreLiteralExpression<T> extends OutreExpression {
  const OutreLiteralExpression(this.token, super.nodeType);

  final OutreToken token;

  T get value => token.literal as T;

  @override
  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        ...super.toJson(),
        'token': token.toJson(),
      };
}
