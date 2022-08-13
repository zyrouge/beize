import '../lexer/exports.dart';

abstract class OutreExpressionPrecedence {
  static const int none = 0;
  static const int comma = 1; // ,
  static const int assignment = 2; // := = ? :
  static const int or = 3; // ||
  static const int and = 4; // &&
  static const int pipe = 5; // |
  static const int caret = 6; // ^
  static const int ampersand = 7; // &
  static const int equality = 8; // == !=
  static const int comparison = 9; // > >= < <=
  static const int sum = 11; // + -
  static const int factor = 12; // * / // %
  static const int exponent = 13; // **
  static const int unary = 14; // ! ~ + -
  static const int call = 17; // ()

  static const Map<OutreTokens, int> precedence = <OutreTokens, int>{
    OutreTokens.comma: comma,
    OutreTokens.colon: comma,
    OutreTokens.declare: assignment,
    OutreTokens.assign: assignment,
    OutreTokens.question: assignment,
    OutreTokens.nullOr: or,
    OutreTokens.logicalOr: or,
    OutreTokens.logicalAnd: and,
    OutreTokens.pipe: pipe,
    OutreTokens.caret: caret,
    OutreTokens.ampersand: ampersand,
    OutreTokens.equal: equality,
    OutreTokens.notEqual: equality,
    OutreTokens.lesserThan: comparison,
    OutreTokens.lesserThanEqual: comparison,
    OutreTokens.greaterThan: comparison,
    OutreTokens.greaterThanEqual: comparison,
    OutreTokens.plus: sum,
    OutreTokens.minus: sum,
    OutreTokens.asterisk: factor,
    OutreTokens.slash: factor,
    OutreTokens.floor: factor,
    OutreTokens.modulo: factor,
    OutreTokens.exponent: exponent,
    OutreTokens.parenLeft: call,
    OutreTokens.dot: call,
    OutreTokens.nullAccess: call,
    OutreTokens.bracketLeft: call,
  };

  static int of(final OutreTokens token) => precedence[token] ?? none;
}
