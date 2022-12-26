import 'package:fubuki_vm/exports.dart';
import '../../errors/exports.dart';
import '../../token/exports.dart';
import '../compiler.dart';
import 'precedence.dart';
import 'rules.dart';

abstract class FubukiParser {
  static void parseStatement(final FubukiCompiler compiler) {
    if (compiler.currentToken.type == FubukiTokens.identifier &&
        compiler.currentToken.literal == 'print') {
      compiler.advance();
      return parsePrintStatement(compiler);
    }
    if (compiler.match(FubukiTokens.braceLeft)) {
      return parseBlockStatement(compiler);
    }
    if (compiler.match(FubukiTokens.ifKw)) {
      return parseIfStatement(compiler);
    }
    if (compiler.match(FubukiTokens.whileKw)) {
      return parseWhileStatement(compiler);
    }
    if (compiler.match(FubukiTokens.breakKw)) {
      return parseBreakStatement(compiler);
    }
    if (compiler.match(FubukiTokens.continueKw)) {
      return parseContinueStatement(compiler);
    }
    if (compiler.match(FubukiTokens.returnKw)) {
      return parseReturnStatement(compiler);
    }
    if (compiler.match(FubukiTokens.throwKw)) {
      return parseThrowStatement(compiler);
    }
    if (compiler.match(FubukiTokens.tryKw)) {
      return parseTryCatchStatement(compiler);
    }
    if (compiler.match(FubukiTokens.importKw)) {
      return parseImportStatement(compiler);
    }
    parseExpressionStatement(compiler);
  }

  static void parsePrintStatement(final FubukiCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(FubukiTokens.semi);
    compiler.emitOpCode(FubukiOpCodes.opPrint);
  }

  static void parseIfStatement(final FubukiCompiler compiler) {
    compiler.consume(FubukiTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(FubukiTokens.parenRight);
    final int thenJump = compiler.emitJump(FubukiOpCodes.opJumpIfFalse);
    compiler.emitOpCode(FubukiOpCodes.opPop);
    parseStatement(compiler);
    final int elseJump = compiler.emitJump(FubukiOpCodes.opJump);
    compiler.patchJump(thenJump);
    compiler.emitOpCode(FubukiOpCodes.opPop);
    if (compiler.match(FubukiTokens.elseKw)) {
      parseStatement(compiler);
    }
    compiler.patchJump(elseJump);
  }

  static void parseWhileStatement(final FubukiCompiler compiler) {
    final int start = compiler.currentChunk.length;
    compiler.consume(FubukiTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(FubukiTokens.parenRight);
    compiler.beginLoop(start);
    compiler.emitOpCode(FubukiOpCodes.opPop);
    parseStatement(compiler);
    compiler.emitLoop(start);
    compiler.endLoop();
  }

  static void parseBreakStatement(final FubukiCompiler compiler) {
    compiler.consume(FubukiTokens.semi);
    compiler.emitBreak();
  }

  static void parseContinueStatement(final FubukiCompiler compiler) {
    compiler.consume(FubukiTokens.semi);
    compiler.emitContinue();
  }

  static void parseBlockStatement(final FubukiCompiler compiler) {
    compiler.emitOpCode(FubukiOpCodes.opBeginScope);
    while (
        !compiler.isEndOfFile() && !compiler.check(FubukiTokens.braceRight)) {
      parseStatement(compiler);
    }
    compiler.emitOpCode(FubukiOpCodes.opEndScope);
    compiler.consume(FubukiTokens.braceRight);
  }

  static void parseReturnStatement(final FubukiCompiler compiler) {
    if (compiler.mode != FubukiCompilerMode.function) {
      throw FubukiIllegalExpressionError.cannotReturnInsideScript(
        compiler.previousToken,
      );
    }
    if (!compiler.check(FubukiTokens.semi)) {
      parseExpression(compiler);
    }
    compiler.consume(FubukiTokens.semi);
    compiler.emitOpCode(FubukiOpCodes.opReturn);
  }

  static void parseThrowStatement(final FubukiCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(FubukiTokens.semi);
    compiler.emitOpCode(FubukiOpCodes.opThrow);
  }

  static void parseTryCatchStatement(final FubukiCompiler compiler) {
    compiler.consume(FubukiTokens.braceLeft);
    final int tryJump = compiler.emitJump(FubukiOpCodes.opBeginTry);
    parseBlockStatement(compiler);
    compiler.emitOpCode(FubukiOpCodes.opEndTry);
    final int catchJump = compiler.emitJump(FubukiOpCodes.opJump);
    compiler.patchAbsoluteJump(tryJump);
    compiler.consume(FubukiTokens.catchKw);
    compiler.consume(FubukiTokens.parenLeft);
    compiler.consume(FubukiTokens.identifier);
    final int index = parseIdentifierConstant(compiler);
    compiler.consume(FubukiTokens.parenRight);
    compiler.emitOpCode(FubukiOpCodes.opBeginScope);
    compiler.emitOpCode(FubukiOpCodes.opDeclare);
    compiler.emitCode(index);
    compiler.consume(FubukiTokens.braceLeft);
    parseBlockStatement(compiler);
    compiler.emitOpCode(FubukiOpCodes.opEndScope);
    compiler.patchJump(catchJump);
  }

  static void parseImportStatement(final FubukiCompiler compiler) {
    compiler.consume(FubukiTokens.string);
    final String modulePath = compiler.previousToken.literal as String;
    final FubukiCompiler moduleCompiler;
    compiler.consume(FubukiTokens.asKw);
    compiler.consume(FubukiTokens.identifier);
    final int moduleIndex = compiler.makeConstant(modulePath);
    final int asIndex = parseIdentifierConstant(compiler);
    compiler.emitOpCode(FubukiOpCodes.opModule);
    compiler.emitCode(moduleIndex);
    compiler.emitCode(asIndex);
  }

  static int parseIdentifierConstant(final FubukiCompiler compiler) {
    final String name = compiler.previousToken.literal as String;
    final int index = compiler.makeConstant(name);
    return index;
  }

  static void parseExpressionStatement(final FubukiCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(FubukiTokens.semi);
    compiler.emitOpCode(FubukiOpCodes.opPop);
  }

  static void parseExpression(final FubukiCompiler compiler) {
    parsePrecedence(compiler, FubukiPrecedence.assignment);
  }

  static void parsePrecedence(
    final FubukiCompiler compiler,
    final FubukiPrecedence precedence,
  ) {
    compiler.advance();
    final FubukiParseRule rule =
        FubukiParseRule.of(compiler.previousToken.type);
    if (rule.prefix == null) {
      // TODO: dont throw
      throw FubukiIllegalExpressionError.expectedXButReceivedToken(
        'expression',
        compiler.previousToken.type,
        compiler.previousToken.span,
      );
    }
    rule.prefix!(compiler);

    FubukiParseRule nextRule = FubukiParseRule.of(compiler.currentToken.type);
    while (precedence.value <= nextRule.precedence.value) {
      compiler.advance();
      nextRule.infix!(compiler);
      nextRule = FubukiParseRule.of(compiler.currentToken.type);
    }
  }

  static void parseUnaryExpression(final FubukiCompiler compiler) {
    final FubukiTokens operator = compiler.previousToken.type;
    parsePrecedence(compiler, FubukiPrecedence.unary);
    switch (operator) {
      case FubukiTokens.plus:
        break;

      case FubukiTokens.minus:
        compiler.emitOpCode(FubukiOpCodes.opNegate);
        break;

      case FubukiTokens.bang:
        compiler.emitOpCode(FubukiOpCodes.opNot);
        break;

      default:
        throw UnreachableError();
    }
  }

  static void parseBinaryExpression(final FubukiCompiler compiler) {
    final FubukiTokens operator = compiler.previousToken.type;
    final FubukiParseRule rule = FubukiParseRule.of(operator);
    parsePrecedence(compiler, rule.precedence.nextPrecedence);

    switch (operator) {
      case FubukiTokens.equal:
        compiler.emitOpCode(FubukiOpCodes.opEqual);
        break;

      case FubukiTokens.notEqual:
        compiler.emitOpCode(FubukiOpCodes.opEqual);
        compiler.emitOpCode(FubukiOpCodes.opNot);
        break;

      case FubukiTokens.lesserThan:
        compiler.emitOpCode(FubukiOpCodes.opLess);
        break;

      case FubukiTokens.lesserThanEqual:
        compiler.emitOpCode(FubukiOpCodes.opGreater);
        compiler.emitOpCode(FubukiOpCodes.opNot);
        break;

      case FubukiTokens.greaterThan:
        compiler.emitOpCode(FubukiOpCodes.opGreater);
        break;

      case FubukiTokens.greaterThanEqual:
        compiler.emitOpCode(FubukiOpCodes.opLess);
        compiler.emitOpCode(FubukiOpCodes.opNot);
        break;

      case FubukiTokens.plus:
        compiler.emitOpCode(FubukiOpCodes.opAdd);
        break;

      case FubukiTokens.minus:
        compiler.emitOpCode(FubukiOpCodes.opSubtract);
        break;

      case FubukiTokens.asterisk:
        compiler.emitOpCode(FubukiOpCodes.opMultiply);
        break;

      case FubukiTokens.slash:
        compiler.emitOpCode(FubukiOpCodes.opDivide);
        break;

      case FubukiTokens.modulo:
        compiler.emitOpCode(FubukiOpCodes.opModulo);
        break;

      case FubukiTokens.exponent:
        compiler.emitOpCode(FubukiOpCodes.opExponent);
        break;

      default:
        throw UnreachableError();
    }
  }

  static void parseNumber(final FubukiCompiler compiler) {
    compiler.emitConstant(compiler.previousToken.literal as double);
  }

  static void parseString(final FubukiCompiler compiler) {
    compiler.emitConstant(compiler.previousToken.literal as String);
  }

  static void parseBoolean(final FubukiCompiler compiler) {
    compiler.emitOpCode(
      compiler.previousToken.type == FubukiTokens.trueKw
          ? FubukiOpCodes.opTrue
          : FubukiOpCodes.opFalse,
    );
  }

  static void parseNull(final FubukiCompiler compiler) {
    compiler.emitOpCode(FubukiOpCodes.opNull);
  }

  static void parseGrouping(final FubukiCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(FubukiTokens.parenRight);
  }

  static void parseIdentifier(final FubukiCompiler compiler) {
    final int index = parseIdentifierConstant(compiler);
    if (compiler.match(FubukiTokens.declare)) {
      parseExpression(compiler);
      compiler.emitOpCode(FubukiOpCodes.opDeclare);
    } else if (compiler.match(FubukiTokens.assign)) {
      parseExpression(compiler);
      compiler.emitOpCode(FubukiOpCodes.opAssign);
    } else {
      compiler.emitOpCode(FubukiOpCodes.opLookup);
    }
    compiler.emitCode(index);
  }

  static void parseLogicalAnd(final FubukiCompiler compiler) {
    final int endJump = compiler.emitJump(FubukiOpCodes.opJumpIfFalse);
    compiler.emitOpCode(FubukiOpCodes.opPop);
    parsePrecedence(compiler, FubukiPrecedence.and);
    compiler.patchJump(endJump);
  }

  static void parseLogicalOr(final FubukiCompiler compiler) {
    final int elseJump = compiler.emitJump(FubukiOpCodes.opJumpIfFalse);
    final int endJump = compiler.emitJump(FubukiOpCodes.opJump);
    compiler.patchJump(elseJump);
    compiler.emitOpCode(FubukiOpCodes.opPop);
    parsePrecedence(compiler, FubukiPrecedence.or);
    compiler.patchJump(endJump);
  }

  static void parseFunction(final FubukiCompiler compiler) {
    final FubukiCompiler functionCompiler = compiler.createFunctionCompiler();
    if (compiler.match(FubukiTokens.parenLeft)) {
      if (!compiler.check(FubukiTokens.parenRight)) {
        do {
          compiler.consume(FubukiTokens.identifier);
          final String arg = compiler.previousToken.literal as String;
          functionCompiler.currentFunction.arguments.add(arg);
        } while (compiler.match(FubukiTokens.comma));
      }
      compiler.consume(FubukiTokens.parenRight);
    }
    compiler.consume(FubukiTokens.braceLeft);
    functionCompiler.copyTokenState(compiler);
    parseBlockStatement(functionCompiler);
    compiler.emitConstant(functionCompiler.currentFunction);
    compiler.copyTokenState(functionCompiler);
  }

  static void parseCall(final FubukiCompiler compiler) {
    int count = 0;
    if (!compiler.check(FubukiTokens.parenRight)) {
      do {
        parseExpression(compiler);
        count++;
      } while (compiler.match(FubukiTokens.comma));
    }
    compiler.consume(FubukiTokens.parenRight);
    compiler.emitOpCode(FubukiOpCodes.opCall);
    compiler.emitCode(count);
  }

  static void parseList(final FubukiCompiler compiler) {
    int count = 0;
    compiler.consume(FubukiTokens.bracketLeft);
    while (!compiler.match(FubukiTokens.bracketRight)) {
      parseExpression(compiler);
      count++;
      compiler.match(FubukiTokens.comma);
    }
    compiler.emitOpCode(FubukiOpCodes.opList);
    compiler.emitCode(count);
  }

  static void parseObjectLike(
    final FubukiCompiler compiler, {
    final bool objectMode = false,
  }) {
    int count = 0;
    compiler.consume(FubukiTokens.braceLeft);
    while (!compiler.match(FubukiTokens.braceRight)) {
      if (!objectMode || compiler.match(FubukiTokens.bracketLeft)) {
        parseExpression(compiler);
        if (objectMode) {
          compiler.consume(FubukiTokens.bracketRight);
        }
      } else {
        compiler.consume(FubukiTokens.identifier);
        final String key = compiler.previousToken.literal as String;
        compiler.emitConstant(key);
      }
      compiler.consume(FubukiTokens.colon);
      parseExpression(compiler);
      compiler.match(FubukiTokens.comma);
      count++;
    }
    compiler.emitOpCode(FubukiOpCodes.opObject);
    compiler.emitCode(count);
  }

  static void parseMap(final FubukiCompiler compiler) {
    parseObjectLike(compiler);
  }

  static void parseObject(final FubukiCompiler compiler) {
    parseObjectLike(compiler, objectMode: true);
  }

  static void parsePropertyCall(
    final FubukiCompiler compiler, {
    final bool dotCall = false,
  }) {
    if (dotCall) {
      compiler.consume(FubukiTokens.identifier);
      final String key = compiler.previousToken.literal as String;
      compiler.emitConstant(key);
    } else {
      parseExpression(compiler);
      compiler.consume(FubukiTokens.bracketRight);
    }
    if (compiler.match(FubukiTokens.assign)) {
      parseExpression(compiler);
      compiler.emitOpCode(FubukiOpCodes.opSetProperty);
    } else {
      compiler.emitOpCode(FubukiOpCodes.opGetProperty);
    }
  }

  static void parseDotCall(final FubukiCompiler compiler) {
    parsePropertyCall(compiler, dotCall: true);
  }

  static void parseBracketCall(final FubukiCompiler compiler) {
    parsePropertyCall(compiler);
  }
}
