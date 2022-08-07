import '../ast/exports.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../utils/exports.dart';
import 'statement.dart';

class OutreParser {
  OutreParser(
    this.tokens, {
    this.reporter = const OutreReporter(),
  });

  final List<OutreToken> tokens;
  late final int length = tokens.length;
  final OutreReporter reporter;

  final OutreModule result = OutreModule(
    statements: <OutreStatement>[],
    errors: <OutreIllegalExpressionError>[],
  );

  int index = 0;

  OutreModule parse() {
    while (!isEndOfFile()) {
      result.statements.add(OutreStatementParser.parseStatement(this));
    }
    return result;
  }

  OutreToken peek() => tokens[index];
  OutreToken previous() => tokens[index - 1];

  OutreToken advance() {
    final OutreToken token = peek();
    if (index + 1 < length) {
      index++;
    }
    return token;
  }

  bool check(final OutreTokens type) => peek().type == type;

  OutreToken consume(final OutreTokens type) {
    if (check(type)) return advance();
    final OutreToken found = peek();
    throw error(
      OutreIllegalExpressionError.expectedTokenButReceivedToken(
        type,
        found.type,
        found.span,
      ),
    );
  }

  OutreToken? maybeConsume(final OutreTokens type) =>
      check(type) ? advance() : null;

  OutreIllegalExpressionError error(final OutreIllegalExpressionError err) {
    result.errors.add(err);
    reporter.reportError('parser', err.toString());
    return err;
  }

  bool isEndOfFile() => check(OutreTokens.eof);
  bool isEndOfStatement() => check(OutreTokens.semi);
}
