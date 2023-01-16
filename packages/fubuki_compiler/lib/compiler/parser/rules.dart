import '../../token/exports.dart';
import '../compiler.dart';
import 'parser.dart';
import 'precedence.dart';

typedef FubukiParseRuleFn = void Function(FubukiCompiler compiler);

class FubukiParseRule {
  const FubukiParseRule({
    this.precedence = FubukiPrecedence.none,
    this.prefix,
    this.infix,
  });

  final FubukiPrecedence precedence;
  final FubukiParseRuleFn? prefix;
  final FubukiParseRuleFn? infix;

  static const FubukiParseRule none = FubukiParseRule();

  static const Map<FubukiTokens, FubukiParseRule> rules =
      <FubukiTokens, FubukiParseRule>{
    FubukiTokens.parenLeft: FubukiParseRule(
      prefix: FubukiParser.parseGrouping,
      infix: FubukiParser.parseCall,
      precedence: FubukiPrecedence.grouping,
    ),
    FubukiTokens.dot: FubukiParseRule(
      infix: FubukiParser.parseDotCall,
      precedence: FubukiPrecedence.call,
    ),
    FubukiTokens.bracketLeft: FubukiParseRule(
      prefix: FubukiParser.parseList,
      infix: FubukiParser.parseBracketCall,
      precedence: FubukiPrecedence.call,
    ),
    FubukiTokens.braceLeft: FubukiParseRule(prefix: FubukiParser.parseObject),
    FubukiTokens.rightArrow:
        FubukiParseRule(prefix: FubukiParser.parseFunction),
    FubukiTokens.question: FubukiParseRule(
      infix: FubukiParser.parseTernary,
      precedence: FubukiPrecedence.assignment,
    ),
    FubukiTokens.nullOr: FubukiParseRule(
      infix: FubukiParser.parseNullOr,
      precedence: FubukiPrecedence.or,
    ),
    FubukiTokens.nullAccess: FubukiParseRule(
      infix: FubukiParser.parseNullAccess,
      precedence: FubukiPrecedence.call,
    ),
    FubukiTokens.bang:
        FubukiParseRule(prefix: FubukiParser.parseUnaryExpression),
    FubukiTokens.tilde:
        FubukiParseRule(prefix: FubukiParser.parseUnaryExpression),
    FubukiTokens.equal: FubukiParseRule(
      precedence: FubukiPrecedence.equality,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.notEqual: FubukiParseRule(
      precedence: FubukiPrecedence.equality,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.lesserThan: FubukiParseRule(
      precedence: FubukiPrecedence.comparison,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.lesserThanEqual: FubukiParseRule(
      precedence: FubukiPrecedence.comparison,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.greaterThan: FubukiParseRule(
      precedence: FubukiPrecedence.comparison,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.greaterThanEqual: FubukiParseRule(
      precedence: FubukiPrecedence.comparison,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.plus: FubukiParseRule(
      precedence: FubukiPrecedence.sum,
      prefix: FubukiParser.parseUnaryExpression,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.minus: FubukiParseRule(
      precedence: FubukiPrecedence.sum,
      prefix: FubukiParser.parseUnaryExpression,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.asterisk: FubukiParseRule(
      precedence: FubukiPrecedence.factor,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.slash: FubukiParseRule(
      precedence: FubukiPrecedence.factor,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.floor: FubukiParseRule(
      precedence: FubukiPrecedence.factor,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.modulo: FubukiParseRule(
      precedence: FubukiPrecedence.factor,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.exponent: FubukiParseRule(
      precedence: FubukiPrecedence.exponent,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.logicalAnd: FubukiParseRule(
      precedence: FubukiPrecedence.and,
      infix: FubukiParser.parseLogicalAnd,
    ),
    FubukiTokens.logicalOr: FubukiParseRule(
      precedence: FubukiPrecedence.or,
      infix: FubukiParser.parseLogicalOr,
    ),
    FubukiTokens.ampersand: FubukiParseRule(
      precedence: FubukiPrecedence.ampersand,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.pipe: FubukiParseRule(
      precedence: FubukiPrecedence.pipe,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.caret: FubukiParseRule(
      precedence: FubukiPrecedence.caret,
      infix: FubukiParser.parseBinaryExpression,
    ),
    FubukiTokens.identifier:
        FubukiParseRule(prefix: FubukiParser.parseIdentifier),
    FubukiTokens.number: FubukiParseRule(prefix: FubukiParser.parseNumber),
    FubukiTokens.string: FubukiParseRule(prefix: FubukiParser.parseString),
    FubukiTokens.trueKw: FubukiParseRule(prefix: FubukiParser.parseBoolean),
    FubukiTokens.falseKw: FubukiParseRule(prefix: FubukiParser.parseBoolean),
    FubukiTokens.nullKw: FubukiParseRule(prefix: FubukiParser.parseNull),
  };

  static FubukiParseRule of(final FubukiTokens type) => rules[type] ?? none;
}
