import '../ast/exports.dart';
import '../lexer/exports.dart';
import 'expression.dart';
import 'parser.dart';
import 'precedence.dart';

typedef OutreStatementParseFn = OutreStatement Function(
  OutreParser parser,
  OutreToken token,
);

abstract class OutreStatementParser {
  static Map<OutreTokens, OutreStatementParseFn> parserFns =
      <OutreTokens, OutreStatementParseFn>{
    OutreTokens.braceLeft: parseBlockStatement,
    OutreTokens.ifKw: parseIfStatement,
    OutreTokens.whileKw: parseWhileStatement,
    OutreTokens.returnKw: parseReturnStatement,
    OutreTokens.breakKw: parseBreakStatement,
    OutreTokens.continueKw: parseContinueStatement,
  };

  static OutreStatement parseStatement(final OutreParser parser) {
    final OutreToken token = parser.advance();
    final OutreStatementParseFn parseFn =
        parserFns[token.type] ?? parseExpressionStatement;
    return parseFn(parser, token);
  }

  static OutreStatement parseIfStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    parser.consume(OutreTokens.parenLeft, 'Expected "(" after "if"');

    final OutreExpression condition = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    parser.consume(OutreTokens.parenRight, 'Expected ")" after "if" condition');

    final OutreStatement whenTrue = OutreStatementParser.parseStatement(parser);
    OutreStatement? whenFalse;
    if (parser.check(OutreTokens.elseKw)) {
      parser.advance();
      whenFalse = OutreStatementParser.parseStatement(parser);
    }

    return OutreIfStatement(keyword, condition, whenTrue, whenFalse);
  }

  static OutreStatement parseWhileStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    parser.consume(OutreTokens.parenLeft, 'Expected "(" after "while"');

    final OutreExpression condition = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    parser.consume(
      OutreTokens.parenRight,
      'Expected ")" after "while" condition',
    );

    final OutreStatement body = OutreStatementParser.parseStatement(parser);

    return OutreWhileStatement(keyword, condition, body);
  }

  static OutreStatement parseReturnStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    final OutreExpression expression = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    return OutreReturnStatement(keyword, expression);
  }

  static OutreStatement parseBreakStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) =>
      OutreBreakStatement(keyword);

  static OutreStatement parseContinueStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) =>
      OutreContinueStatement(keyword);

  static OutreStatement parseBlockStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    final List<OutreStatement> statements = <OutreStatement>[];
    while (!parser.check(OutreTokens.braceRight)) {
      statements.add(parseStatement(parser));
    }
    final OutreToken end =
        parser.consume(OutreTokens.braceRight, 'Expected "}" after block');
    return OutreBlockStatement(keyword, statements, end);
  }

  static OutreStatement parseExpressionStatement(
    final OutreParser parser,
    final OutreToken token,
  ) {
    final OutreExpression expression =
        OutreExpressionParser.parsePeekedExpression(
      parser,
      token,
      precedence: OutreExpressionPrecedence.none,
    );
    return OutreExpressionStatement(expression);
  }
}
