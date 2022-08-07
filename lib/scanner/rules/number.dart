import '../../lexer/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class OutreNumberScanner {
  static const OutreScannerCustomRule rule =
      OutreScannerCustomRule(matches, readNumber);

  static bool matches(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      OutreLexerUtils.isNumeric(current.char);

  static OutreToken readNumber(
    final OutreScanner scanner,
    final OutreInputIteration start,
  ) {
    final OutreStrictStringBuffer buffer = OutreStrictStringBuffer(start.char);

    OutreInputIteration current = start;
    bool hasDot = false;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!OutreLexerUtils.isNumeric(current.char)) break;
      if (current.char == OutreTokens.dot.code) {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(current.char);
      scanner.input.advance();
    }

    return OutreToken(
      OutreTokens.number,
      double.parse(buffer.toString()),
      OutreSpan(start.point, current.point),
    );
  }
}
