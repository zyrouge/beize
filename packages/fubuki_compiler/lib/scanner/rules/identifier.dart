import '../../lexer/exports.dart';
import '../../token/exports.dart';
import '../scanner.dart';
import '../utils.dart';
import 'rules.dart';

abstract class FubukiIdentifierScanner {
  static const FubukiScannerCustomRule rule =
      FubukiScannerCustomRule(matches, readIdentifier);

  static const Set<FubukiTokens> keywords = <FubukiTokens>{
    FubukiTokens.trueKw,
    FubukiTokens.falseKw,
    FubukiTokens.ifKw,
    FubukiTokens.elseKw,
    FubukiTokens.whileKw,
    FubukiTokens.nullKw,
    FubukiTokens.funKw,
    FubukiTokens.returnKw,
    FubukiTokens.breakKw,
    FubukiTokens.continueKw,
    FubukiTokens.objKw,
    FubukiTokens.tryKw,
    FubukiTokens.catchKw,
    FubukiTokens.throwKw,
    FubukiTokens.importKw,
    FubukiTokens.asKw,
    FubukiTokens.listKw,
    FubukiTokens.mapKw,
  };

  static final Map<String, FubukiTokens> keywordsMap = keywords.asNameMap().map(
        (final _, final FubukiTokens x) =>
            MapEntry<String, FubukiTokens>(x.code, x),
      );

  static bool matches(
    final FubukiScanner scanner,
    final FubukiInputIteration current,
  ) =>
      FubukiLexerUtils.isAlphaNumeric(current.char);

  static FubukiToken readIdentifier(
    final FubukiScanner scanner,
    final FubukiInputIteration start,
  ) {
    final FubukiStringBuffer buffer = FubukiStringBuffer(start.char);
    FubukiInputIteration current = start;
    while (!scanner.input.isEndOfLine()) {
      current = scanner.input.peek();
      if (!FubukiLexerUtils.isAlphaNumeric(current.char)) break;
      buffer.write(current.char);
      scanner.input.advance();
    }
    final String output = buffer.toString();
    return FubukiToken(
      keywordsMap[output] ?? FubukiTokens.identifier,
      output,
      FubukiSpan(start.point, current.point),
    );
  }
}
