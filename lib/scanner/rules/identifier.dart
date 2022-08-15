import '../../lexer/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class OutreIdentifierScanner {
  static const OutreScannerCustomRule rule =
      OutreScannerCustomRule(matches, readIdentifier);

  static const Set<OutreTokens> keywords = <OutreTokens>{
    OutreTokens.trueKw,
    OutreTokens.falseKw,
    OutreTokens.ifKw,
    OutreTokens.elseKw,
    OutreTokens.whileKw,
    OutreTokens.nullKw,
    OutreTokens.fnKw,
    OutreTokens.returnKw,
    OutreTokens.breakKw,
    OutreTokens.continueKw,
    OutreTokens.objKw,
    OutreTokens.tryKw,
    OutreTokens.catchKw,
    OutreTokens.throwKw,
    OutreTokens.importKw,
    OutreTokens.asKw,
  };

  static final Map<String, OutreTokens> keywordsMap = keywords.asNameMap().map(
        (final _, final OutreTokens x) =>
            MapEntry<String, OutreTokens>(x.code, x),
      );

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
      keywordsMap[output] ?? OutreTokens.identifier,
      output,
      OutreSpan(start.point, current.point),
    );
  }
}
