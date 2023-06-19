import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class BeizeIdentifierScanner {
  static const BeizeScannerCustomRule rule =
      BeizeScannerCustomRule(matches, readIdentifier);

  static const Set<BeizeTokens> keywords = <BeizeTokens>{
    BeizeTokens.trueKw,
    BeizeTokens.falseKw,
    BeizeTokens.ifKw,
    BeizeTokens.elseKw,
    BeizeTokens.whileKw,
    BeizeTokens.nullKw,
    BeizeTokens.returnKw,
    BeizeTokens.breakKw,
    BeizeTokens.continueKw,
    BeizeTokens.tryKw,
    BeizeTokens.catchKw,
    BeizeTokens.throwKw,
    BeizeTokens.importKw,
    BeizeTokens.asKw,
    BeizeTokens.whenKw,
    BeizeTokens.matchKw,
    BeizeTokens.printKw,
    BeizeTokens.forKw,
    BeizeTokens.asyncKw,
    BeizeTokens.awaitKw,
  };

  static final Map<String, BeizeTokens> keywordsMap = keywords.asNameMap().map(
        (final _, final BeizeTokens x) =>
            MapEntry<String, BeizeTokens>(x.code, x),
      );

  static bool matches(
    final BeizeScanner scanner,
    final BeizeInputIteration current,
  ) =>
      BeizeLexerUtils.isAlphaNumeric(current.char);

  static BeizeToken readIdentifier(
    final BeizeScanner scanner,
    final BeizeInputIteration start,
  ) {
    final BeizeStringBuffer buffer = BeizeStringBuffer(start.char);
    BeizeInputIteration current = start;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!BeizeLexerUtils.isAlphaNumeric(current.char)) break;
      buffer.write(current.char);
      scanner.input.advance();
    }
    final String output = buffer.toString();
    return BeizeToken(
      keywordsMap[output] ?? BeizeTokens.identifier,
      output,
      BeizeSpan(start.point, current.point),
    );
  }
}
