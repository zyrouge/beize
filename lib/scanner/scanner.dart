import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../utils/exports.dart';
import 'rules/exports.dart';

class OutreScannerResult {
  final List<OutreToken> tokens = <OutreToken>[];
  final List<OutreIllegalExpressionError> errors =
      <OutreIllegalExpressionError>[];

  bool get hasErrors => errors.isNotEmpty;
}

class OutreScanner {
  OutreScanner(
    this.input, {
    this.reporter = const OutreReporter(),
  });

  final OutreInput input;
  final OutreReporter reporter;
  final OutreScannerResult result = OutreScannerResult();

  OutreScannerResult scan() {
    while (!input.isEndOfFile()) {
      addToken(readToken());
    }
    return result;
  }

  OutreToken readToken() {
    input.skipWhitespace();
    final OutreInputIteration current = input.advance();
    return OutreScannerRules.scan(this, current);
  }

  void addToken(final OutreToken token) {
    result.tokens.add(token);
    if (token.type == OutreTokens.illegal) {
      final OutreIllegalExpressionError err =
          OutreIllegalExpressionError.illegalToken(token);
      result.errors.add(err);
      reporter.reportError('scanner', err.toString());
    }
  }
}
