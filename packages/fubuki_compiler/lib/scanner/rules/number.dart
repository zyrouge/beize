import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class FubukiNumberScanner {
  static const FubukiScannerCustomRule rule =
      FubukiScannerCustomRule(matches, readNumber);

  static bool matches(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      FubukiLexerUtils.isNumeric(current.char);

  static FubukiToken readNumber(
    final FubukiScanner scanner,
    final FubukiInputIteration start,
  ) {
    final FubukiStringBuffer buffer = FubukiStringBuffer(start.char);

    FubukiInputIteration current = start;
    bool hasDot = false;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!FubukiLexerUtils.isNumericContent(current.char)) break;
      if (current.char == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(current.char);
      scanner.input.advance();
    }

    return FubukiToken(
      FubukiTokens.number,
      num.parse(buffer.toString()).toDouble(),
      FubukiSpan(start.point, current.point),
    );
  }
}
