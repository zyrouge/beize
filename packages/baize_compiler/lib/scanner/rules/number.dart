import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class BaizeNumberScanner {
  static const BaizeScannerCustomRule rule =
      BaizeScannerCustomRule(matches, readNumber);

  static bool matches(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      BaizeLexerUtils.isNumeric(current.char);

  static BaizeToken readNumber(
    final BaizeScanner scanner,
    final BaizeInputIteration start,
  ) {
    final BaizeStringBuffer buffer = BaizeStringBuffer(start.char);

    BaizeInputIteration current = start;
    bool hasDot = false;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!BaizeLexerUtils.isNumericContent(current.char)) break;
      if (current.char == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(current.char);
      scanner.input.advance();
    }

    return BaizeToken(
      BaizeTokens.number,
      num.parse(buffer.toString()).toDouble(),
      BaizeSpan(start.point, current.point),
    );
  }
}
