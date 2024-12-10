import '../../token/exports.dart';
import '../compiler.dart';
import 'parser.dart';
import 'precedence.dart';

typedef BeizeParseRuleFn = void Function(BeizeCompiler compiler);

class BeizeParseRule {
  const BeizeParseRule({
    this.precedence = BeizePrecedence.none,
    this.prefix,
    this.infix,
  });

  final BeizePrecedence precedence;
  final BeizeParseRuleFn? prefix;
  final BeizeParseRuleFn? infix;

  static const BeizeParseRule none = BeizeParseRule();

  static const Map<BeizeTokens, BeizeParseRule> rules =
      <BeizeTokens, BeizeParseRule>{
    BeizeTokens.parenLeft: BeizeParseRule(
      prefix: BeizeParser.parseGrouping,
      infix: BeizeParser.parseCall,
      precedence: BeizePrecedence.grouping,
    ),
    BeizeTokens.dot: BeizeParseRule(
      infix: BeizeParser.parseDotCall,
      precedence: BeizePrecedence.call,
    ),
    BeizeTokens.bracketLeft: BeizeParseRule(
      prefix: BeizeParser.parseList,
      infix: BeizeParser.parseBracketCall,
      precedence: BeizePrecedence.call,
    ),
    BeizeTokens.braceLeft: BeizeParseRule(prefix: BeizeParser.parseObject),
    BeizeTokens.rightArrow: BeizeParseRule(prefix: BeizeParser.parseFunction),
    BeizeTokens.question: BeizeParseRule(
      infix: BeizeParser.parseTernary,
      precedence: BeizePrecedence.assignment,
    ),
    BeizeTokens.nullOr: BeizeParseRule(
      infix: BeizeParser.parseNullOr,
      precedence: BeizePrecedence.or,
    ),
    BeizeTokens.nullAccess: BeizeParseRule(
      infix: BeizeParser.parseNullAccess,
      precedence: BeizePrecedence.call,
    ),
    BeizeTokens.bang: BeizeParseRule(prefix: BeizeParser.parseUnaryExpression),
    BeizeTokens.tilde: BeizeParseRule(prefix: BeizeParser.parseUnaryExpression),
    BeizeTokens.equal: BeizeParseRule(
      precedence: BeizePrecedence.equality,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.notEqual: BeizeParseRule(
      precedence: BeizePrecedence.equality,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.lesserThan: BeizeParseRule(
      precedence: BeizePrecedence.comparison,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.lesserThanEqual: BeizeParseRule(
      precedence: BeizePrecedence.comparison,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.greaterThan: BeizeParseRule(
      precedence: BeizePrecedence.comparison,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.greaterThanEqual: BeizeParseRule(
      precedence: BeizePrecedence.comparison,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.isKw: BeizeParseRule(
      precedence: BeizePrecedence.comparison,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.plus: BeizeParseRule(
      precedence: BeizePrecedence.sum,
      prefix: BeizeParser.parseUnaryExpression,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.minus: BeizeParseRule(
      precedence: BeizePrecedence.sum,
      prefix: BeizeParser.parseUnaryExpression,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.asterisk: BeizeParseRule(
      precedence: BeizePrecedence.factor,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.slash: BeizeParseRule(
      precedence: BeizePrecedence.factor,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.floor: BeizeParseRule(
      precedence: BeizePrecedence.factor,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.modulo: BeizeParseRule(
      precedence: BeizePrecedence.factor,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.exponent: BeizeParseRule(
      precedence: BeizePrecedence.exponent,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.logicalAnd: BeizeParseRule(
      precedence: BeizePrecedence.and,
      infix: BeizeParser.parseLogicalAnd,
    ),
    BeizeTokens.logicalOr: BeizeParseRule(
      precedence: BeizePrecedence.or,
      infix: BeizeParser.parseLogicalOr,
    ),
    BeizeTokens.ampersand: BeizeParseRule(
      precedence: BeizePrecedence.ampersand,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.pipe: BeizeParseRule(
      precedence: BeizePrecedence.pipe,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.caret: BeizeParseRule(
      precedence: BeizePrecedence.caret,
      infix: BeizeParser.parseBinaryExpression,
    ),
    BeizeTokens.identifier: BeizeParseRule(prefix: BeizeParser.parseIdentifier),
    BeizeTokens.number: BeizeParseRule(prefix: BeizeParser.parseNumber),
    BeizeTokens.string: BeizeParseRule(prefix: BeizeParser.parseString),
    BeizeTokens.trueKw: BeizeParseRule(prefix: BeizeParser.parseBoolean),
    BeizeTokens.falseKw: BeizeParseRule(prefix: BeizeParser.parseBoolean),
    BeizeTokens.nullKw: BeizeParseRule(prefix: BeizeParser.parseNull),
  };

  static BeizeParseRule of(final BeizeTokens type) => rules[type] ?? none;
}
