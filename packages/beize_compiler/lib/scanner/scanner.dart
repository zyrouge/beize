import '../lexer/exports.dart';
import '../token/exports.dart';
import 'rules/exports.dart';

class BeizeScanner {
  BeizeScanner(this.input);

  final BeizeInput input;

  BeizeToken readToken() {
    input.skipWhitespace();
    final BeizeInputIteration current = input.advance();
    return BeizeScannerRules.scan(this, current);
  }
}
