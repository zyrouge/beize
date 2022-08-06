import '../ast/exports.dart';
import '../node/exports.dart';
import 'environment.dart';

abstract class OutreEvaluator {
  static final OutreEnvironment environment = OutreEnvironment.global();

  static dynamic eval(final OutreNode node) {
    if (node is OutreProgram) {
      return evalProgram(node);
    } else if (node is OutreLiteralExpression) {
      return node.token.literal;
    }
  }

  static dynamic evalProgram(final OutreProgram program) {}
}
