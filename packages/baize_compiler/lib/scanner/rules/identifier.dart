import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class BaizeIdentifierScanner {
  static const BaizeScannerCustomRule rule =
      BaizeScannerCustomRule(matches, readIdentifier);

  static const Set<BaizeTokens> keywords = <BaizeTokens>{
    BaizeTokens.trueKw,
    BaizeTokens.falseKw,
    BaizeTokens.ifKw,
    BaizeTokens.elseKw,
    BaizeTokens.whileKw,
    BaizeTokens.nullKw,
    BaizeTokens.returnKw,
    BaizeTokens.breakKw,
    BaizeTokens.continueKw,
    BaizeTokens.tryKw,
    BaizeTokens.catchKw,
    BaizeTokens.throwKw,
    BaizeTokens.importKw,
    BaizeTokens.asKw,
    BaizeTokens.whenKw,
    BaizeTokens.matchKw,
    BaizeTokens.printKw,
    BaizeTokens.forKw,
  };

  static final Map<String, BaizeTokens> keywordsMap = keywords.asNameMap().map(
        (final _, final BaizeTokens x) =>
            MapEntry<String, BaizeTokens>(x.code, x),
      );

  static bool matches(
    final BaizeScanner scanner,
    final BaizeInputIteration current,
  ) =>
      BaizeLexerUtils.isAlphaNumeric(current.char);

  static BaizeToken readIdentifier(
    final BaizeScanner scanner,
    final BaizeInputIteration start,
  ) {
    final BaizeStringBuffer buffer = BaizeStringBuffer(start.char);
    BaizeInputIteration current = start;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!BaizeLexerUtils.isAlphaNumeric(current.char)) break;
      buffer.write(current.char);
      scanner.input.advance();
    }
    final String output = buffer.toString();
    return BaizeToken(
      keywordsMap[output] ?? BaizeTokens.identifier,
      output,
      BaizeSpan(start.point, current.point),
    );
  }
}
