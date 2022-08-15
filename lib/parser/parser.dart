import 'dart:io';
import '../ast/exports.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../scanner/exports.dart';
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
    index++;
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

  static OutreModule parseSource(final String source) {
    final OutreInput input = OutreInput(source);
    final OutreScannerResult sResult = OutreScanner(input).scan();
    if (sResult.hasErrors) {
      throw Exception('Exiting as scanner returned errors');
    }
    final OutreParser parser = OutreParser(sResult.tokens);
    return parser.parse();
  }

  static Future<OutreModule> parseFile(final String path) async {
    final File file = File(path);
    return parseSource(await file.readAsString());
  }
}
