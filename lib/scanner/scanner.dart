import '../lexer/exports.dart';
import 'rules/exports.dart';

class OutreScanner {
  OutreScanner(this.input);

  final OutreInput input;
  final List<OutreToken> tokens = <OutreToken>[];

  List<OutreToken> scan() {
    while (!input.isEndOfFile()) {
      tokens.add(readToken());
    }
    return tokens;
  }

  OutreToken readToken() {
    input.skipWhitespace();
    final OutreInputIteration current = input.advance();
    return OutreScannerRules.scan(this, current);
  }
}
