import 'package:baize_shared/baize_shared.dart';
import '../../errors/exports.dart';
import '../../token/exports.dart';
import '../compiler.dart';
import 'precedence.dart';
import 'rules.dart';

abstract class BaizeParser {
  static Future<void> parseStatement(final BaizeCompiler compiler) async {
    if (compiler.match(BaizeTokens.braceLeft)) {
      return parseBlockStatement(compiler);
    }
    if (compiler.match(BaizeTokens.ifKw)) {
      return parseIfStatement(compiler);
    }
    if (compiler.match(BaizeTokens.whileKw)) {
      return parseWhileStatement(compiler);
    }
    if (compiler.match(BaizeTokens.breakKw)) {
      return parseBreakStatement(compiler);
    }
    if (compiler.match(BaizeTokens.continueKw)) {
      return parseContinueStatement(compiler);
    }
    if (compiler.match(BaizeTokens.returnKw)) {
      return parseReturnStatement(compiler);
    }
    if (compiler.match(BaizeTokens.throwKw)) {
      return parseThrowStatement(compiler);
    }
    if (compiler.match(BaizeTokens.tryKw)) {
      return parseTryCatchStatement(compiler);
    }
    if (compiler.match(BaizeTokens.importKw)) {
      return parseImportStatement(compiler);
    }
    if (compiler.match(BaizeTokens.whenKw)) {
      return parseWhenStatement(compiler);
    }
    if (compiler.match(BaizeTokens.matchKw)) {
      return parseMatchStatement(compiler);
    }
    if (compiler.match(BaizeTokens.printKw)) {
      return parsePrintStatement(compiler);
    }
    if (compiler.match(BaizeTokens.forKw)) {
      return parseForStatement(compiler);
    }
    return parseExpressionStatement(compiler);
  }

  static void parsePrintStatement(final BaizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BaizeTokens.semi);
    compiler.emitOpCode(BaizeOpCodes.opPrint);
  }

  static void parseIfStatement(final BaizeCompiler compiler) {
    compiler.consume(BaizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BaizeTokens.parenRight);
    final int thenJump = compiler.emitJump(BaizeOpCodes.opJumpIfFalse);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parseStatement(compiler);
    final int elseJump = compiler.emitJump(BaizeOpCodes.opJump);
    compiler.patchJump(thenJump);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    if (compiler.match(BaizeTokens.elseKw)) {
      parseStatement(compiler);
    }
    compiler.patchJump(elseJump);
  }

  static void parseWhileStatement(final BaizeCompiler compiler) {
    final int start = compiler.currentAbsoluteOffset;
    compiler.consume(BaizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BaizeTokens.parenRight);
    compiler.beginLoop(start);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parseStatement(compiler);
    final int jump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(jump, start);
    compiler.endLoop();
  }

  static void parseForStatement(final BaizeCompiler compiler) {
    compiler.consume(BaizeTokens.parenLeft);
    if (!compiler.check(BaizeTokens.semi)) {
      parseExpression(compiler);
      compiler.emitOpCode(BaizeOpCodes.opPop);
    }
    compiler.consume(BaizeTokens.semi);
    final int conditionOffset = compiler.currentAbsoluteOffset;
    if (!compiler.check(BaizeTokens.semi)) {
      parseExpression(compiler);
    } else {
      compiler.emitOpCode(BaizeOpCodes.opTrue);
    }
    compiler.consume(BaizeTokens.semi);
    final int updateJump = compiler.emitJump(BaizeOpCodes.opJump);
    final int updateOffset = compiler.currentAbsoluteOffset;
    if (!compiler.check(BaizeTokens.semi)) {
      parseExpression(compiler);
      compiler.emitOpCode(BaizeOpCodes.opPop);
    }
    final int conditionJump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(conditionJump, conditionOffset);
    compiler.patchJump(updateJump);
    compiler.consume(BaizeTokens.parenRight);
    compiler.beginLoop(updateOffset);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parseStatement(compiler);
    final int jump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(jump, updateOffset);
    compiler.endLoop();
  }

  static void parseBreakStatement(final BaizeCompiler compiler) {
    if (compiler.loops.isEmpty) {
      throw BaizeCompilationException.cannotBreakContinueOutsideLoop(
        compiler.module,
        compiler.previousToken,
      );
    }
    compiler.consume(BaizeTokens.semi);
    compiler.emitBreak();
  }

  static void parseContinueStatement(final BaizeCompiler compiler) {
    if (compiler.loops.isEmpty) {
      throw BaizeCompilationException.cannotBreakContinueOutsideLoop(
        compiler.module,
        compiler.previousToken,
      );
    }
    compiler.consume(BaizeTokens.semi);
    compiler.emitContinue();
  }

  static void parseBlockStatement(final BaizeCompiler compiler) {
    compiler.emitOpCode(BaizeOpCodes.opBeginScope);
    while (
        !compiler.isEndOfFile() && !compiler.check(BaizeTokens.braceRight)) {
      parseStatement(compiler);
    }
    compiler.emitOpCode(BaizeOpCodes.opEndScope);
    compiler.consume(BaizeTokens.braceRight);
  }

  static void parseReturnStatement(final BaizeCompiler compiler) {
    if (compiler.mode != BaizeCompilerMode.function) {
      throw BaizeCompilationException.cannotReturnInsideScript(
        compiler.module,
        compiler.previousToken,
      );
    }
    if (!compiler.check(BaizeTokens.semi)) {
      parseExpression(compiler);
    }
    compiler.consume(BaizeTokens.semi);
    compiler.emitOpCode(BaizeOpCodes.opReturn);
  }

  static void parseThrowStatement(final BaizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BaizeTokens.semi);
    compiler.emitOpCode(BaizeOpCodes.opThrow);
  }

  static void parseTryCatchStatement(final BaizeCompiler compiler) {
    compiler.consume(BaizeTokens.braceLeft);
    final int tryJump = compiler.emitJump(BaizeOpCodes.opBeginTry);
    parseBlockStatement(compiler);
    compiler.emitOpCode(BaizeOpCodes.opEndTry);
    final int catchJump = compiler.emitJump(BaizeOpCodes.opJump);
    compiler.patchAbsoluteJump(tryJump);
    compiler.consume(BaizeTokens.catchKw);
    compiler.consume(BaizeTokens.parenLeft);
    compiler.consume(BaizeTokens.identifier);
    final int index = parseIdentifierConstant(compiler);
    compiler.consume(BaizeTokens.parenRight);
    compiler.emitOpCode(BaizeOpCodes.opBeginScope);
    compiler.emitOpCode(BaizeOpCodes.opDeclare);
    compiler.emitCode(index);
    compiler.consume(BaizeTokens.braceLeft);
    parseBlockStatement(compiler);
    compiler.emitOpCode(BaizeOpCodes.opEndScope);
    compiler.patchJump(catchJump);
  }

  static Future<void> parseImportStatement(
    final BaizeCompiler compiler,
  ) async {
    if (compiler.scopeDepth != 0) {
      throw BaizeCompilationException.topLevelImports(
        compiler.module,
        compiler.previousToken,
      );
    }
    compiler.consume(BaizeTokens.string);
    final String importPath =
        compiler.resolveImportPath(compiler.previousToken.literal as String);
    final String modulePath = compiler.resolveImportPath(importPath);
    final int moduleIndex = compiler.makeConstant(modulePath);
    compiler.consume(BaizeTokens.asKw);
    compiler.consume(BaizeTokens.identifier);
    final int asIndex = parseIdentifierConstant(compiler);
    compiler.consume(BaizeTokens.semi);
    compiler.emitOpCode(BaizeOpCodes.opModule);
    compiler.emitCode(moduleIndex);
    compiler.emitCode(asIndex);
    if (!compiler.modules.containsKey(modulePath)) {
      final BaizeCompiler moduleCompiler =
          await compiler.createModuleCompiler(importPath);
      compiler.modules[modulePath] = moduleCompiler.currentFunction;
      await moduleCompiler.compile();
    }
  }

  static void parseMatchableStatement(
    final BaizeCompiler compiler,
    final void Function() matcher,
  ) {
    final List<_BaizeMatchableCase> cases = <_BaizeMatchableCase>[];
    _BaizeMatchableCase? elseCase;
    final int startJump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
    compiler.consume(BaizeTokens.braceLeft);
    while (!compiler.match(BaizeTokens.braceRight)) {
      final int start = compiler.currentAbsoluteOffset;
      if (compiler.match(BaizeTokens.elseKw)) {
        if (elseCase != null) {
          throw BaizeCompilationException.duplicateElse(
            compiler.module,
            compiler.previousToken,
          );
        }
        compiler.consume(BaizeTokens.colon);
        parseStatement(compiler);
        final int exitJump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
        elseCase = _BaizeMatchableCase(start, exitJump, -1);
      } else {
        matcher();
        compiler.consume(BaizeTokens.colon);
        final int localJump = compiler.emitJump(BaizeOpCodes.opJumpIfFalse);
        parseStatement(compiler);
        compiler.emitOpCode(BaizeOpCodes.opPop);
        final int exitJump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
        compiler.patchJump(localJump);
        compiler.emitOpCode(BaizeOpCodes.opPop);
        final int thenJump = compiler.emitJump(BaizeOpCodes.opAbsoluteJump);
        cases.add(_BaizeMatchableCase(start, thenJump, exitJump));
      }
    }
    final int end = compiler.currentAbsoluteOffset;
    for (int i = 0; i < cases.length; i++) {
      final _BaizeMatchableCase x = cases[i];
      compiler.patchAbsoluteJumpTo(
        x.thenJump,
        i + 1 < cases.length ? cases[i + 1].start : elseCase?.start ?? end,
      );
      compiler.patchAbsoluteJumpTo(x.elseJump, end);
    }
    if (elseCase != null) {
      compiler.patchAbsoluteJumpTo(elseCase.thenJump, end);
    }
    compiler.patchAbsoluteJumpTo(
      startJump,
      cases.isNotEmpty ? cases.first.start : elseCase?.start ?? end,
    );
  }

  static void parseWhenStatement(final BaizeCompiler compiler) {
    parseMatchableStatement(compiler, () {
      parseExpression(compiler);
    });
  }

  static void parseMatchStatement(final BaizeCompiler compiler) {
    compiler.consume(BaizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BaizeTokens.parenRight);
    parseMatchableStatement(compiler, () {
      compiler.emitOpCode(BaizeOpCodes.opTop);
      parseExpression(compiler);
      compiler.emitOpCode(BaizeOpCodes.opEqual);
    });
    compiler.emitOpCode(BaizeOpCodes.opPop);
  }

  static int parseIdentifierConstant(final BaizeCompiler compiler) {
    final String name = compiler.previousToken.literal as String;
    final int index = compiler.makeConstant(name);
    return index;
  }

  static void parseExpressionStatement(final BaizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BaizeTokens.semi);
    compiler.emitOpCode(BaizeOpCodes.opPop);
  }

  static void parseExpression(final BaizeCompiler compiler) {
    parsePrecedence(compiler, BaizePrecedence.assignment);
  }

  static void parsePrecedence(
    final BaizeCompiler compiler,
    final BaizePrecedence precedence,
  ) {
    compiler.advance();
    final BaizeParseRule rule =
        BaizeParseRule.of(compiler.previousToken.type);
    if (rule.prefix == null) {
      throw BaizeCompilationException.expectedXButReceivedToken(
        compiler.module,
        'expression',
        compiler.previousToken.type,
        compiler.previousToken.span,
      );
    }
    rule.prefix!(compiler);
    parseInfixExpression(compiler, precedence);
  }

  static void parseInfixExpression(
    final BaizeCompiler compiler,
    final BaizePrecedence precedence,
  ) {
    BaizeParseRule nextRule = BaizeParseRule.of(compiler.currentToken.type);
    while (precedence.value <= nextRule.precedence.value) {
      compiler.advance();
      nextRule.infix!(compiler);
      nextRule = BaizeParseRule.of(compiler.currentToken.type);
    }
  }

  static void parseUnaryExpression(final BaizeCompiler compiler) {
    final BaizeTokens operator = compiler.previousToken.type;
    parsePrecedence(compiler, BaizePrecedence.unary);
    switch (operator) {
      case BaizeTokens.plus:
        break;

      case BaizeTokens.minus:
        compiler.emitOpCode(BaizeOpCodes.opNegate);
        break;

      case BaizeTokens.bang:
        compiler.emitOpCode(BaizeOpCodes.opNot);
        break;

      case BaizeTokens.tilde:
        compiler.emitOpCode(BaizeOpCodes.opBitwiseNot);
        break;

      default:
        throw UnreachableException();
    }
  }

  static void parseBinaryExpression(final BaizeCompiler compiler) {
    final BaizeTokens operator = compiler.previousToken.type;
    final BaizeParseRule rule = BaizeParseRule.of(operator);
    parsePrecedence(compiler, rule.precedence.nextPrecedence);
    switch (operator) {
      case BaizeTokens.equal:
        compiler.emitOpCode(BaizeOpCodes.opEqual);
        break;

      case BaizeTokens.notEqual:
        compiler.emitOpCode(BaizeOpCodes.opEqual);
        compiler.emitOpCode(BaizeOpCodes.opNot);
        break;

      case BaizeTokens.lesserThan:
        compiler.emitOpCode(BaizeOpCodes.opLess);
        break;

      case BaizeTokens.lesserThanEqual:
        compiler.emitOpCode(BaizeOpCodes.opGreater);
        compiler.emitOpCode(BaizeOpCodes.opNot);
        break;

      case BaizeTokens.greaterThan:
        compiler.emitOpCode(BaizeOpCodes.opGreater);
        break;

      case BaizeTokens.greaterThanEqual:
        compiler.emitOpCode(BaizeOpCodes.opLess);
        compiler.emitOpCode(BaizeOpCodes.opNot);
        break;

      case BaizeTokens.plus:
        compiler.emitOpCode(BaizeOpCodes.opAdd);
        break;

      case BaizeTokens.minus:
        compiler.emitOpCode(BaizeOpCodes.opSubtract);
        break;

      case BaizeTokens.asterisk:
        compiler.emitOpCode(BaizeOpCodes.opMultiply);
        break;

      case BaizeTokens.slash:
        compiler.emitOpCode(BaizeOpCodes.opDivide);
        break;

      case BaizeTokens.floor:
        compiler.emitOpCode(BaizeOpCodes.opFloor);
        break;

      case BaizeTokens.modulo:
        compiler.emitOpCode(BaizeOpCodes.opModulo);
        break;

      case BaizeTokens.exponent:
        compiler.emitOpCode(BaizeOpCodes.opExponent);
        break;

      case BaizeTokens.ampersand:
        compiler.emitOpCode(BaizeOpCodes.opBitwiseAnd);
        break;

      case BaizeTokens.pipe:
        compiler.emitOpCode(BaizeOpCodes.opBitwiseOr);
        break;

      case BaizeTokens.caret:
        compiler.emitOpCode(BaizeOpCodes.opBitwiseXor);
        break;

      default:
        throw UnreachableException();
    }
  }

  static void parseNumber(final BaizeCompiler compiler) {
    compiler.emitConstant(compiler.previousToken.literal as double);
  }

  static void parseString(final BaizeCompiler compiler) {
    compiler.emitConstant(compiler.previousToken.literal as String);
  }

  static void parseBoolean(final BaizeCompiler compiler) {
    compiler.emitOpCode(
      compiler.previousToken.type == BaizeTokens.trueKw
          ? BaizeOpCodes.opTrue
          : BaizeOpCodes.opFalse,
    );
  }

  static void parseNull(final BaizeCompiler compiler) {
    compiler.emitOpCode(BaizeOpCodes.opNull);
  }

  static void parseGrouping(final BaizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BaizeTokens.parenRight);
  }

  static void parseIdentifier(final BaizeCompiler compiler) {
    final int index = parseIdentifierConstant(compiler);
    bool emitIndex = true;

    void emitLookup() {
      compiler.emitOpCode(BaizeOpCodes.opLookup);
      compiler.emitCode(index);
    }

    void emitAssign() {
      compiler.emitOpCode(BaizeOpCodes.opAssign);
    }

    void emitAssignAndIndex() {
      compiler.emitOpCode(BaizeOpCodes.opAssign);
      compiler.emitCode(index);
    }

    void emitExprAssign(final BaizeOpCodes opCode) {
      emitLookup();
      parsePrecedence(compiler, BaizePrecedence.assignment);
      compiler.emitOpCode(opCode);
      emitAssign();
    }

    if (compiler.match(BaizeTokens.declare)) {
      parseExpression(compiler);
      compiler.emitOpCode(BaizeOpCodes.opDeclare);
    } else if (compiler.match(BaizeTokens.assign)) {
      parseExpression(compiler);
      emitAssign();
    } else if (compiler.match(BaizeTokens.increment)) {
      emitLookup();
      compiler.emitConstant(1.0);
      compiler.emitOpCode(BaizeOpCodes.opAdd);
      emitAssign();
    } else if (compiler.match(BaizeTokens.decrement)) {
      emitLookup();
      compiler.emitConstant(1.0);
      compiler.emitOpCode(BaizeOpCodes.opSubtract);
      emitAssign();
    } else if (compiler.match(BaizeTokens.plusEqual)) {
      emitExprAssign(BaizeOpCodes.opAdd);
    } else if (compiler.match(BaizeTokens.minusEqual)) {
      emitExprAssign(BaizeOpCodes.opSubtract);
    } else if (compiler.match(BaizeTokens.asteriskEqual)) {
      emitExprAssign(BaizeOpCodes.opMultiply);
    } else if (compiler.match(BaizeTokens.exponentEqual)) {
      emitExprAssign(BaizeOpCodes.opExponent);
    } else if (compiler.match(BaizeTokens.slashEqual)) {
      emitExprAssign(BaizeOpCodes.opDivide);
    } else if (compiler.match(BaizeTokens.floorEqual)) {
      emitExprAssign(BaizeOpCodes.opFloor);
    } else if (compiler.match(BaizeTokens.moduloEqual)) {
      emitExprAssign(BaizeOpCodes.opModulo);
    } else if (compiler.match(BaizeTokens.ampersandEqual)) {
      emitExprAssign(BaizeOpCodes.opBitwiseAnd);
    } else if (compiler.match(BaizeTokens.pipeEqual)) {
      emitExprAssign(BaizeOpCodes.opBitwiseOr);
    } else if (compiler.match(BaizeTokens.caretEqual)) {
      emitExprAssign(BaizeOpCodes.opBitwiseXor);
    } else if (compiler.match(BaizeTokens.logicalAndEqual)) {
      emitIndex = false;
      emitLookup();
      parseLogicalAnd(
        compiler,
        precedence: BaizePrecedence.assignment,
        beforePatch: emitAssignAndIndex,
      );
    } else if (compiler.match(BaizeTokens.logicalOrEqual)) {
      emitIndex = false;
      emitLookup();
      parseLogicalOr(
        compiler,
        precedence: BaizePrecedence.assignment,
        beforePatch: emitAssignAndIndex,
      );
    } else if (compiler.match(BaizeTokens.nullOrEqual)) {
      emitIndex = false;
      emitLookup();
      parseNullOr(
        compiler,
        precedence: BaizePrecedence.assignment,
        beforePatch: emitAssignAndIndex,
      );
    } else {
      compiler.emitOpCode(BaizeOpCodes.opLookup);
    }
    if (emitIndex) {
      compiler.emitCode(index);
    }
  }

  static void parseLogicalAnd(
    final BaizeCompiler compiler, {
    final BaizePrecedence precedence = BaizePrecedence.and,
    final void Function()? beforePatch,
  }) {
    final int endJump = compiler.emitJump(BaizeOpCodes.opJumpIfFalse);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parsePrecedence(compiler, precedence);
    beforePatch?.call();
    compiler.patchJump(endJump);
  }

  static void parseLogicalOr(
    final BaizeCompiler compiler, {
    final BaizePrecedence precedence = BaizePrecedence.or,
    final void Function()? beforePatch,
  }) {
    final int elseJump = compiler.emitJump(BaizeOpCodes.opJumpIfFalse);
    final int endJump = compiler.emitJump(BaizeOpCodes.opJump);
    compiler.patchJump(elseJump);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parsePrecedence(compiler, precedence);
    beforePatch?.call();
    compiler.patchJump(endJump);
  }

  static void parseFunction(final BaizeCompiler compiler) {
    final BaizeCompiler functionCompiler = compiler.createFunctionCompiler();
    bool cont = true;
    while (cont && functionCompiler.check(BaizeTokens.identifier)) {
      functionCompiler.consume(BaizeTokens.identifier);
      final String arg = functionCompiler.previousToken.literal as String;
      functionCompiler.currentFunction.arguments.add(arg);
      cont = functionCompiler.match(BaizeTokens.comma);
    }
    if (functionCompiler.match(BaizeTokens.colon)) {
      parseExpression(functionCompiler);
      functionCompiler.emitOpCode(BaizeOpCodes.opReturn);
    } else {
      functionCompiler.match(BaizeTokens.braceLeft);
      parseBlockStatement(functionCompiler);
    }
    compiler.emitConstant(functionCompiler.currentFunction);
    compiler.copyTokenState(functionCompiler);
  }

  static void parseCall(final BaizeCompiler compiler) {
    int count = 0;
    bool cont = true;
    while (cont && !compiler.check(BaizeTokens.parenRight)) {
      parseExpression(compiler);
      count++;
      cont = compiler.match(BaizeTokens.comma);
    }
    compiler.consume(BaizeTokens.parenRight);
    compiler.emitOpCode(BaizeOpCodes.opCall);
    compiler.emitCode(count);
  }

  static void parseList(final BaizeCompiler compiler) {
    int count = 0;
    bool cont = true;
    while (cont && !compiler.check(BaizeTokens.bracketRight)) {
      parseExpression(compiler);
      count++;
      cont = compiler.match(BaizeTokens.comma);
    }
    compiler.consume(BaizeTokens.bracketRight);
    compiler.emitOpCode(BaizeOpCodes.opList);
    compiler.emitCode(count);
  }

  static void parseObject(final BaizeCompiler compiler) {
    int count = 0;
    bool cont = true;
    while (cont && !compiler.check(BaizeTokens.braceRight)) {
      if (compiler.match(BaizeTokens.bracketLeft)) {
        parseExpression(compiler);
        compiler.consume(BaizeTokens.bracketRight);
      } else {
        compiler.consume(BaizeTokens.identifier);
        final String key = compiler.previousToken.literal as String;
        compiler.emitConstant(key);
      }
      compiler.consume(BaizeTokens.colon);
      parseExpression(compiler);
      count++;
      cont = compiler.match(BaizeTokens.comma);
    }
    compiler.consume(BaizeTokens.braceRight);
    compiler.emitOpCode(BaizeOpCodes.opObject);
    compiler.emitCode(count);
  }

  static void parsePropertyCall(
    final BaizeCompiler compiler, {
    final bool dotCall = false,
  }) {
    if (dotCall) {
      compiler.consume(BaizeTokens.identifier);
      final String key = compiler.previousToken.literal as String;
      compiler.emitConstant(key);
    } else {
      parseExpression(compiler);
      compiler.consume(BaizeTokens.bracketRight);
    }
    if (compiler.match(BaizeTokens.assign)) {
      parseExpression(compiler);
      compiler.emitOpCode(BaizeOpCodes.opSetProperty);
    } else {
      compiler.emitOpCode(BaizeOpCodes.opGetProperty);
    }
  }

  static void parseDotCall(final BaizeCompiler compiler) {
    parsePropertyCall(compiler, dotCall: true);
  }

  static void parseBracketCall(final BaizeCompiler compiler) {
    parsePropertyCall(compiler);
  }

  static void parseTernary(final BaizeCompiler compiler) {
    final int thenJump = compiler.emitJump(BaizeOpCodes.opJumpIfFalse);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parseExpression(compiler);
    final int elseJump = compiler.emitJump(BaizeOpCodes.opJump);
    compiler.patchJump(thenJump);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    compiler.consume(BaizeTokens.colon);
    parseExpression(compiler);
    compiler.patchJump(elseJump);
  }

  static void parseNullOr(
    final BaizeCompiler compiler, {
    final BaizePrecedence precedence = BaizePrecedence.or,
    final void Function()? beforePatch,
  }) {
    final int elseJump = compiler.emitJump(BaizeOpCodes.opJumpIfNull);
    final int endJump = compiler.emitJump(BaizeOpCodes.opJump);
    compiler.patchJump(elseJump);
    compiler.emitOpCode(BaizeOpCodes.opPop);
    parsePrecedence(compiler, precedence);
    beforePatch?.call();
    compiler.patchJump(endJump);
  }

  static void parseNullAccess(final BaizeCompiler compiler) {
    final int exitJump = compiler.emitJump(BaizeOpCodes.opJumpIfNull);
    if (compiler.match(BaizeTokens.parenLeft)) {
      parseCall(compiler);
    } else {
      parsePropertyCall(
        compiler,
        dotCall: !compiler.match(BaizeTokens.bracketLeft),
      );
    }
    parseInfixExpression(compiler, BaizePrecedence.call);
    compiler.patchJump(exitJump);
  }
}

class _BaizeMatchableCase {
  const _BaizeMatchableCase(this.start, this.thenJump, this.elseJump);

  final int start;
  final int thenJump;
  final int elseJump;
}
