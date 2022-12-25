import '../lexer/exports.dart';
import '../token/exports.dart';
import 'rules/exports.dart';

class FubukiScanner {
  FubukiScanner(this.input);

  final FubukiInput input;

  FubukiToken readToken() {
    input.skipWhitespace();
    final FubukiInputIteration current = input.advance();
    return FubukiScannerRules.scan(this, current);
  }
}
