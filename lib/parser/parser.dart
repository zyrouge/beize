import '../ast/exports.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import 'statement.dart';

class OutreParser {
  OutreParser(this.tokens);

  final List<OutreToken> tokens;
  late final int length = tokens.length;

  int index = 0;

  OutreProgram parse() {
    final List<OutreStatement> statements = <OutreStatement>[];
    while (!isEndOfFile()) {
      statements.add(OutreStatementParser.parseStatement(this));
    }
    return OutreProgram(statements);
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

  OutreToken consume(final OutreTokens type, final String message) {
    if (check(type)) return advance();
    throw error(message, peek().span);
  }

  OutreIllegalExpressionError error(
    final String message,
    final OutreSpan span,
  ) =>
      OutreIllegalExpressionError(message, span);

  bool isEndOfFile() => check(OutreTokens.eof);
}
