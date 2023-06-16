import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class BeizeNumberScanner {
  static const BeizeScannerCustomRule rule =
      BeizeScannerCustomRule(matches, readNumber);

  static bool matches(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      BeizeLexerUtils.isNumeric(current.char);

  static BeizeToken readNumber(
    final BeizeScanner scanner,
    final BeizeInputIteration start,
  ) {
    final BeizeStringBuffer buffer = BeizeStringBuffer(start.char);

    BeizeInputIteration current = start;
    bool hasDot = false;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!BeizeLexerUtils.isNumericContent(current.char)) break;
      if (current.char == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(current.char);
      scanner.input.advance();
    }

    return BeizeToken(
      BeizeTokens.number,
      num.parse(buffer.toString()).toDouble(),
      BeizeSpan(start.point, current.point),
    );
  }
}
