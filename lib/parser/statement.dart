import '../ast/exports.dart';
import '../lexer/exports.dart';
import '../node/exports.dart';
import 'expression.dart';
import 'parser.dart';
import 'precedence.dart';
import 'utils.dart';

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
    OutreTokens.tryKw: parseTryCatchStatement,
    OutreTokens.throwKw: parseThrowStatement,
    OutreTokens.importKw: parseImportStatement,
  };

  static OutreStatement parseStatement(final OutreParser parser) {
    final OutreToken token = parser.advance();
    final OutreStatementParseFn parseFn =
        parserFns[token.type] ?? parseExpressionStatement;
    final OutreStatement statement = parseFn(parser, token);
    return statement;
  }

  static OutreStatement parseIfStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    parser.consume(OutreTokens.parenLeft);
    final OutreExpression condition = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    parser.consume(OutreTokens.parenRight);
    final OutreStatement whenTrue = parseStatement(parser);
    OutreStatement? whenFalse;
    if (parser.check(OutreTokens.elseKw)) {
      parser.advance();
      whenFalse = parseStatement(parser);
    }
    return OutreIfStatement(keyword, condition, whenTrue, whenFalse);
  }

  static OutreStatement parseWhileStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    parser.consume(OutreTokens.parenLeft);
    final OutreExpression condition = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    parser.consume(OutreTokens.parenRight);
    final OutreStatement body = parseStatement(parser);
    return OutreWhileStatement(keyword, condition, body);
  }

  static OutreStatement parseReturnStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    final OutreExpression? expression = !parser.check(OutreTokens.semi)
        ? OutreExpressionParser.parseExpression(
            parser,
            precedence: OutreExpressionPrecedence.none,
          )
        : null;
    parser.maybeConsume(OutreTokens.semi);
    return OutreReturnStatement(keyword, expression);
  }

  static OutreStatement parseBreakStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    parser.maybeConsume(OutreTokens.semi);
    return OutreBreakStatement(keyword);
  }

  static OutreStatement parseContinueStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    parser.maybeConsume(OutreTokens.semi);
    return OutreContinueStatement(keyword);
  }

  static OutreStatement parseBlockStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    final List<OutreStatement> statements = <OutreStatement>[];
    while (!parser.check(OutreTokens.braceRight)) {
      statements.add(parseStatement(parser));
    }
    final OutreToken end = parser.consume(OutreTokens.braceRight);
    parser.maybeConsume(OutreTokens.semi);
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
    parser.maybeConsume(OutreTokens.semi);
    return OutreExpressionStatement(expression);
  }

  static OutreStatement parseTryCatchStatement(
    final OutreParser parser,
    final OutreToken tryKeyword,
  ) {
    final OutreStatement tryBlock = parseStatement(parser);
    final OutreToken catchKeyword = parser.consume(OutreTokens.catchKw);
    parser.consume(OutreTokens.parenLeft);
    final List<OutreExpression> catchParameters =
        OutreExpressionParser.parseExpressions(
      parser,
      seperator: OutreTokens.comma,
      delimitier: OutreTokens.parenRight,
    );
    OutreParserUtils.assertNodesType(
      OutreNodes.identifierExpr,
      catchParameters,
    );
    parser.consume(OutreTokens.parenRight);
    final OutreStatement catchBlock = parseStatement(parser);
    return OutreTryCatchStatement(
      tryKeyword,
      tryBlock,
      catchKeyword,
      catchParameters,
      catchBlock,
    );
  }

  static OutreStatement parseThrowStatement(
    final OutreParser parser,
    final OutreToken keyword,
  ) {
    final OutreExpression expression = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    parser.maybeConsume(OutreTokens.semi);
    return OutreThrowStatement(keyword, expression);
  }

  static OutreStatement parseImportStatement(
    final OutreParser parser,
    final OutreToken importKw,
  ) {
    final OutreExpression path = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    OutreParserUtils.assertNodeType(OutreNodes.stringExpr, path);
    final OutreToken asKw = parser.consume(OutreTokens.asKw);
    final OutreExpression name = OutreExpressionParser.parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    OutreParserUtils.assertNodeType(OutreNodes.identifierExpr, name);
    parser.maybeConsume(OutreTokens.semi);
    return OutreImportStatement(importKw, path, asKw, name);
  }
}
