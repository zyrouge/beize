import '../lexer/exports.dart';
import '../token/exports.dart';
import 'rules/exports.dart';

class BaizeScanner {
  BaizeScanner(this.input);

  final BaizeInput input;

  BaizeToken readToken() {
    input.skipWhitespace();
    final BaizeInputIteration current = input.advance();
    return BaizeScannerRules.scan(this, current);
  }
}
