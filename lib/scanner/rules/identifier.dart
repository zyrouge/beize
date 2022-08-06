import '../../lexer/exports.dart';
import '../scanner.dart';
import '../utils.dart';

abstract class OutreIdentifierScanner {
  static const Map<String, OutreTokens> keywords = <String, OutreTokens>{
    'true': OutreTokens.trueKw,
    'false': OutreTokens.falseKw,
    'if': OutreTokens.ifKw,
    'else': OutreTokens.elseKw,
    'while': OutreTokens.whileKw,
    'null': OutreTokens.nullKw,
    'fn': OutreTokens.fnKw,
    'return': OutreTokens.returnKw,
    'break': OutreTokens.breakKw,
    'continue': OutreTokens.continueKw,
  };

  static bool matches(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      OutreLexerUtils.isAlphaNumeric(current.char);

  static OutreToken readIdentifier(
    final OutreScanner scanner,
    final OutreInputIteration start,
  ) {
    final OutreStrictStringBuffer buffer = OutreStrictStringBuffer(start.char);
    OutreInputIteration current = start;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!OutreLexerUtils.isAlphaNumeric(current.char)) break;
      buffer.write(current.char);
      scanner.input.advance();
    }
    final String output = buffer.toString();
    return OutreToken(
      keywords[output] ?? OutreTokens.identifier,
      output,
      OutreSpan(start.point, current.point),
    );
  }
}
