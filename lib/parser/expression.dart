import '../ast/exports.dart';
import '../lexer/exports.dart';
import 'parser.dart';
import 'precedence.dart';
import 'statement.dart';

typedef OutrePrefixExpressionParseFn = OutreExpression Function(
  OutreParser parser,
  OutreToken operator,
);

typedef OutreInfixExpressionParseFn = OutreExpression Function(
  OutreParser parser,
  OutreExpression left,
  OutreToken operator, {
  required int precedence,
});

abstract class OutreExpressionParser {
  static final Map<OutreTokens, OutrePrefixExpressionParseFn> prefixParseFns =
      <OutreTokens, OutrePrefixExpressionParseFn>{
    OutreTokens.identifier: parseIdentifier,
    OutreTokens.number: parseNumberLiteral,
    OutreTokens.string: parseStringLiteral,
    OutreTokens.parenLeft: parseGroupedExpression,
    OutreTokens.bracketLeft: parseArrayLiteral,
    OutreTokens.plus: parsePrefixExpression,
    OutreTokens.minus: parsePrefixExpression,
    OutreTokens.tilde: parsePrefixExpression,
    OutreTokens.bang: parsePrefixExpression,
    OutreTokens.trueKw: parseBooleanLiteral,
    OutreTokens.falseKw: parseBooleanLiteral,
    OutreTokens.nullKw: parseNullLiteral,
    OutreTokens.fnKw: parseFunctionLiteral,
  };

  static final Map<OutreTokens, OutreInfixExpressionParseFn> infixParseFns =
      <OutreTokens, OutreInfixExpressionParseFn>{
    OutreTokens.parenLeft: parseCallExpression,
    OutreTokens.question: parseInfixExpression,
    OutreTokens.colon: parseInfixExpression,
    OutreTokens.assign: parseInfixExpression,
    OutreTokens.declare: parseInfixExpression,
    OutreTokens.plus: parseInfixExpression,
    OutreTokens.minus: parseInfixExpression,
    OutreTokens.asterisk: parseInfixExpression,
    OutreTokens.exponent: parseInfixExpression,
    OutreTokens.slash: parseInfixExpression,
    OutreTokens.floor: parseInfixExpression,
    OutreTokens.modulo: parseInfixExpression,
    OutreTokens.caret: parseInfixExpression,
    OutreTokens.equal: parseInfixExpression,
    OutreTokens.notEqual: parseInfixExpression,
    OutreTokens.lesserThan: parseInfixExpression,
    OutreTokens.greaterThan: parseInfixExpression,
    OutreTokens.lesserThanEqual: parseInfixExpression,
    OutreTokens.greaterThanEqual: parseInfixExpression,
    OutreTokens.ampersand: parseInfixExpression,
    OutreTokens.and: parseInfixExpression,
    OutreTokens.pipe: parseInfixExpression,
    OutreTokens.or: parseInfixExpression,
  };

  static OutreExpression parseExpression(
    final OutreParser parser, {
    required final int precedence,
  }) {
    final OutreToken token = parser.advance();
    return parsePeekedExpression(parser, token, precedence: precedence);
  }

  static OutreExpression parsePeekedExpression(
    final OutreParser parser,
    final OutreToken token, {
    required final int precedence,
  }) {
    final OutrePrefixExpressionParseFn? prefixFn = prefixParseFns[token.type];
    if (prefixFn == null) {
      throw parser.error('Expected expression', token.span);
    }

    OutreExpression expression = prefixFn(parser, token);
    int peekPrecedence = OutreExpressionPrecedence.of(parser.peek().type);
    while (!parser.isEndOfFile() && precedence < peekPrecedence) {
      final OutreToken token = parser.peek();
      final OutreInfixExpressionParseFn? infixFn = infixParseFns[token.type];
      if (infixFn == null) break;

      parser.advance();
      expression = infixFn(
        parser,
        expression,
        token,
        precedence: precedence,
      );
      peekPrecedence = OutreExpressionPrecedence.of(parser.peek().type);
    }

    return expression;
  }

  static OutreExpression parsePrefixExpression(
    final OutreParser parser,
    final OutreToken operator,
  ) {
    final OutreExpression right = parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.unary,
    );
    return OutreUnaryExpression(operator, right);
  }

  static OutreExpression parseInfixExpression(
    final OutreParser parser,
    final OutreExpression left,
    final OutreToken operator, {
    required final int precedence,
  }) {
    final OutreExpression right = parseExpression(
      parser,
      precedence: precedence,
    );
    return OutreBinaryExpression(left, operator, right);
  }

  static OutreExpression parseIdentifier(
    final OutreParser parser,
    final OutreToken name,
  ) =>
      OutreIdentifierExpression(name);

  static OutreExpression parseNumberLiteral(
    final OutreParser parser,
    final OutreToken literal,
  ) =>
      OutreLiteralExpression(literal);

  static OutreExpression parseStringLiteral(
    final OutreParser parser,
    final OutreToken literal,
  ) =>
      OutreLiteralExpression(literal);

  static OutreExpression parseGroupedExpression(
    final OutreParser parser,
    final OutreToken start,
  ) {
    final OutreExpression expression = parseExpression(
      parser,
      precedence: OutreExpressionPrecedence.none,
    );
    final OutreToken end =
        parser.consume(OutreTokens.parenRight, 'Expected ")" after group');
    return OutreGroupingExpression(start, expression, end);
  }

  static OutreExpression parseBooleanLiteral(
    final OutreParser parser,
    final OutreToken literal,
  ) =>
      OutreLiteralExpression(literal.setLiteral(literal.literal == 'true'));

  static OutreExpression parseNullLiteral(
    final OutreParser parser,
    final OutreToken literal,
  ) =>
      OutreLiteralExpression(literal.setLiteral(null));

  static OutreExpression parseFunctionLiteral(
    final OutreParser parser,
    final OutreToken token,
  ) {
    OutreFunctionExpressionParameters? parameters;
    if (parser.check(OutreTokens.parenLeft)) {
      final OutreToken start = parser.advance();
      final List<OutreToken> elements = <OutreToken>[];
      while (!parser.check(OutreTokens.parenRight)) {
        elements.add(
          parser.consume(
            OutreTokens.identifier,
            'Expected identifier after function parenthesis',
          ),
        );
        if (parser.check(OutreTokens.parenRight)) break;
        parser.consume(
          OutreTokens.comma,
          'Expected "," after function argument',
        );
      }
      final OutreToken end = parser.consume(
        OutreTokens.parenRight,
        'Expected ")" after function arguments',
      );
      parameters = OutreFunctionExpressionParameters(start, elements, end);
    }
    final OutreStatement body = OutreStatementParser.parseStatement(parser);
    return OutreFunctionExpression(token, parameters, body);
  }

  static OutreExpression parseCallExpression(
    final OutreParser parser,
    final OutreExpression callee,
    final OutreToken start, {
    required final int precedence,
  }) {
    final List<OutreExpression> arguments = <OutreExpression>[];
    while (!parser.check(OutreTokens.parenRight)) {
      arguments.add(parseExpression(parser, precedence: precedence));
      if (parser.check(OutreTokens.parenRight)) break;
      parser.consume(
        OutreTokens.comma,
        'Expected "," after function argument',
      );
    }
    final OutreToken end = parser.consume(
      OutreTokens.parenRight,
      'Expected ")" after function arguments',
    );
    return OutreCallExpression(
      callee,
      OutreCallExpressionArguments(start, arguments, end),
    );
  }

  static OutreExpression parseArrayLiteral(
    final OutreParser parser,
    final OutreToken start,
  ) {
    final List<OutreExpression> elements = <OutreExpression>[];
    while (!parser.check(OutreTokens.bracketRight)) {
      elements.add(
        parseExpression(
          parser,
          precedence: OutreExpressionPrecedence.none,
        ),
      );
      if (parser.check(OutreTokens.bracketRight)) break;
      parser.consume(
        OutreTokens.comma,
        'Expected "," after array element',
      );
    }
    final OutreToken end = parser.consume(
      OutreTokens.bracketRight,
      'Expected "]" after array literal',
    );
    return OutreArrayExpression(start, elements, end);
  }
}
