import '../../token/exports.dart';
import '../compiler.dart';
import 'parser.dart';
import 'precedence.dart';

typedef BaizeParseRuleFn = void Function(BaizeCompiler compiler);

class BaizeParseRule {
  const BaizeParseRule({
    this.precedence = BaizePrecedence.none,
    this.prefix,
    this.infix,
  });

  final BaizePrecedence precedence;
  final BaizeParseRuleFn? prefix;
  final BaizeParseRuleFn? infix;

  static const BaizeParseRule none = BaizeParseRule();

  static const Map<BaizeTokens, BaizeParseRule> rules =
      <BaizeTokens, BaizeParseRule>{
    BaizeTokens.parenLeft: BaizeParseRule(
      prefix: BaizeParser.parseGrouping,
      infix: BaizeParser.parseCall,
      precedence: BaizePrecedence.grouping,
    ),
    BaizeTokens.dot: BaizeParseRule(
      infix: BaizeParser.parseDotCall,
      precedence: BaizePrecedence.call,
    ),
    BaizeTokens.bracketLeft: BaizeParseRule(
      prefix: BaizeParser.parseList,
      infix: BaizeParser.parseBracketCall,
      precedence: BaizePrecedence.call,
    ),
    BaizeTokens.braceLeft: BaizeParseRule(prefix: BaizeParser.parseObject),
    BaizeTokens.rightArrow:
        BaizeParseRule(prefix: BaizeParser.parseFunction),
    BaizeTokens.question: BaizeParseRule(
      infix: BaizeParser.parseTernary,
      precedence: BaizePrecedence.assignment,
    ),
    BaizeTokens.nullOr: BaizeParseRule(
      infix: BaizeParser.parseNullOr,
      precedence: BaizePrecedence.or,
    ),
    BaizeTokens.nullAccess: BaizeParseRule(
      infix: BaizeParser.parseNullAccess,
      precedence: BaizePrecedence.call,
    ),
    BaizeTokens.bang:
        BaizeParseRule(prefix: BaizeParser.parseUnaryExpression),
    BaizeTokens.tilde:
        BaizeParseRule(prefix: BaizeParser.parseUnaryExpression),
    BaizeTokens.equal: BaizeParseRule(
      precedence: BaizePrecedence.equality,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.notEqual: BaizeParseRule(
      precedence: BaizePrecedence.equality,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.lesserThan: BaizeParseRule(
      precedence: BaizePrecedence.comparison,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.lesserThanEqual: BaizeParseRule(
      precedence: BaizePrecedence.comparison,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.greaterThan: BaizeParseRule(
      precedence: BaizePrecedence.comparison,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.greaterThanEqual: BaizeParseRule(
      precedence: BaizePrecedence.comparison,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.plus: BaizeParseRule(
      precedence: BaizePrecedence.sum,
      prefix: BaizeParser.parseUnaryExpression,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.minus: BaizeParseRule(
      precedence: BaizePrecedence.sum,
      prefix: BaizeParser.parseUnaryExpression,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.asterisk: BaizeParseRule(
      precedence: BaizePrecedence.factor,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.slash: BaizeParseRule(
      precedence: BaizePrecedence.factor,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.floor: BaizeParseRule(
      precedence: BaizePrecedence.factor,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.modulo: BaizeParseRule(
      precedence: BaizePrecedence.factor,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.exponent: BaizeParseRule(
      precedence: BaizePrecedence.exponent,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.logicalAnd: BaizeParseRule(
      precedence: BaizePrecedence.and,
      infix: BaizeParser.parseLogicalAnd,
    ),
    BaizeTokens.logicalOr: BaizeParseRule(
      precedence: BaizePrecedence.or,
      infix: BaizeParser.parseLogicalOr,
    ),
    BaizeTokens.ampersand: BaizeParseRule(
      precedence: BaizePrecedence.ampersand,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.pipe: BaizeParseRule(
      precedence: BaizePrecedence.pipe,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.caret: BaizeParseRule(
      precedence: BaizePrecedence.caret,
      infix: BaizeParser.parseBinaryExpression,
    ),
    BaizeTokens.identifier:
        BaizeParseRule(prefix: BaizeParser.parseIdentifier),
    BaizeTokens.number: BaizeParseRule(prefix: BaizeParser.parseNumber),
    BaizeTokens.string: BaizeParseRule(prefix: BaizeParser.parseString),
    BaizeTokens.trueKw: BaizeParseRule(prefix: BaizeParser.parseBoolean),
    BaizeTokens.falseKw: BaizeParseRule(prefix: BaizeParser.parseBoolean),
    BaizeTokens.nullKw: BaizeParseRule(prefix: BaizeParser.parseNull),
  };

  static BaizeParseRule of(final BaizeTokens type) => rules[type] ?? none;
}
