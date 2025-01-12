import 'package:beize_shared/beize_shared.dart';
import '../../errors/exports.dart';
import '../../token/exports.dart';
import '../compiler.dart';
import 'precedence.dart';
import 'rules.dart';

typedef _BeizeMatchableCase = ({
  int start,
  int thenJump,
  int elseJump,
});

abstract class BeizeParser {
  static Future<void> parseStatement(final BeizeCompiler compiler) async {
    if (compiler.match(BeizeTokens.braceLeft)) {
      return parseBlockStatement(compiler);
    }
    if (compiler.match(BeizeTokens.ifKw)) {
      return parseIfStatement(compiler);
    }
    if (compiler.match(BeizeTokens.whileKw)) {
      return parseWhileStatement(compiler);
    }
    if (compiler.match(BeizeTokens.breakKw)) {
      return parseBreakStatement(compiler);
    }
    if (compiler.match(BeizeTokens.continueKw)) {
      return parseContinueStatement(compiler);
    }
    if (compiler.match(BeizeTokens.returnKw)) {
      return parseReturnStatement(compiler);
    }
    if (compiler.match(BeizeTokens.throwKw)) {
      return parseThrowStatement(compiler);
    }
    if (compiler.match(BeizeTokens.tryKw)) {
      return parseTryCatchStatement(compiler);
    }
    if (compiler.match(BeizeTokens.importKw)) {
      return parseImportStatement(compiler);
    }
    if (compiler.match(BeizeTokens.whenKw)) {
      return parseWhenStatement(compiler);
    }
    if (compiler.match(BeizeTokens.matchKw)) {
      return parseMatchStatement(compiler);
    }
    if (compiler.match(BeizeTokens.printKw)) {
      return parsePrintStatement(compiler);
    }
    if (compiler.match(BeizeTokens.forKw)) {
      return parseForStatement(compiler);
    }
    return parseExpressionStatement(compiler);
  }

  static void parsePrintStatement(final BeizeCompiler compiler) {
    compiler.consume(BeizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BeizeTokens.parenRight);
    compiler.consume(BeizeTokens.semi);
    if (!compiler.options.disablePrint) {
      compiler.emitOpCode(BeizeOpCodes.opPrint);
    } else {
      compiler.emitOpCode(BeizeOpCodes.opPop);
    }
  }

  static void parseIfStatement(final BeizeCompiler compiler) {
    compiler.consume(BeizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BeizeTokens.parenRight);
    final int thenJump = compiler.emitJump(BeizeOpCodes.opJumpIfFalse);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parseStatement(compiler);
    final int elseJump = compiler.emitJump(BeizeOpCodes.opJump);
    compiler.patchJump(thenJump);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    if (compiler.match(BeizeTokens.elseKw)) {
      parseStatement(compiler);
    }
    compiler.patchJump(elseJump);
  }

  static void parseWhileStatement(final BeizeCompiler compiler) {
    final int start = compiler.currentAbsoluteOffset;
    compiler.consume(BeizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BeizeTokens.parenRight);
    compiler.beginLoop(start);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parseStatement(compiler);
    final int jump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(jump, start);
    compiler.endLoop();
  }

  static void parseForStatement(final BeizeCompiler compiler) {
    compiler.consume(BeizeTokens.parenLeft);
    if (!compiler.check(BeizeTokens.semi)) {
      parseExpression(compiler);
      compiler.emitOpCode(BeizeOpCodes.opPop);
    }
    compiler.consume(BeizeTokens.semi);
    final int conditionOffset = compiler.currentAbsoluteOffset;
    if (!compiler.check(BeizeTokens.semi)) {
      parseExpression(compiler);
    } else {
      compiler.emitOpCode(BeizeOpCodes.opTrue);
    }
    compiler.consume(BeizeTokens.semi);
    final int updateJump = compiler.emitJump(BeizeOpCodes.opJump);
    final int updateOffset = compiler.currentAbsoluteOffset;
    if (!compiler.check(BeizeTokens.parenRight)) {
      parseExpression(compiler);
      compiler.emitOpCode(BeizeOpCodes.opPop);
    }
    final int conditionJump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(conditionJump, conditionOffset);
    compiler.patchJump(updateJump);
    compiler.consume(BeizeTokens.parenRight);
    compiler.beginLoop(updateOffset);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parseStatement(compiler);
    final int jump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
    compiler.patchAbsoluteJumpTo(jump, updateOffset);
    compiler.endLoop();
  }

  static void parseBreakStatement(final BeizeCompiler compiler) {
    if (compiler.loops.isEmpty) {
      throw BeizeCompilationException.cannotBreakContinueOutsideLoop(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    compiler.consume(BeizeTokens.semi);
    compiler.emitBreak();
  }

  static void parseContinueStatement(final BeizeCompiler compiler) {
    if (compiler.loops.isEmpty) {
      throw BeizeCompilationException.cannotBreakContinueOutsideLoop(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    compiler.consume(BeizeTokens.semi);
    compiler.emitContinue();
  }

  static void parseBlockStatement(final BeizeCompiler compiler) {
    compiler.emitOpCode(BeizeOpCodes.opBeginScope);
    while (!compiler.isEndOfFile() && !compiler.check(BeizeTokens.braceRight)) {
      parseStatement(compiler);
    }
    compiler.emitOpCode(BeizeOpCodes.opEndScope);
    compiler.consume(BeizeTokens.braceRight);
  }

  static void parseReturnStatement(final BeizeCompiler compiler) {
    if (compiler.mode != BeizeCompilerMode.function) {
      throw BeizeCompilationException.cannotReturnInsideScript(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    if (!compiler.check(BeizeTokens.semi)) {
      parseExpression(compiler);
    } else {
      compiler.emitOpCode(BeizeOpCodes.opNull);
    }
    compiler.consume(BeizeTokens.semi);
    compiler.emitOpCode(BeizeOpCodes.opReturn);
  }

  static void parseThrowStatement(final BeizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BeizeTokens.semi);
    compiler.emitOpCode(BeizeOpCodes.opThrow);
  }

  static void parseTryCatchStatement(final BeizeCompiler compiler) {
    compiler.consume(BeizeTokens.braceLeft);
    final int tryJump = compiler.emitJump(BeizeOpCodes.opBeginTry);
    parseBlockStatement(compiler);
    compiler.emitOpCode(BeizeOpCodes.opEndTry);
    final int catchJump = compiler.emitJump(BeizeOpCodes.opJump);
    compiler.patchAbsoluteJump(tryJump);
    compiler.consume(BeizeTokens.catchKw);
    compiler.consume(BeizeTokens.parenLeft);
    compiler.consume(BeizeTokens.identifier);
    final int index = parseIdentifierConstant(compiler);
    compiler.consume(BeizeTokens.parenRight);
    compiler.emitOpCode(BeizeOpCodes.opBeginScope);
    compiler.emitOpCode(BeizeOpCodes.opDeclare);
    compiler.emitCode(index);
    compiler.consume(BeizeTokens.braceLeft);
    parseBlockStatement(compiler);
    compiler.emitOpCode(BeizeOpCodes.opEndScope);
    compiler.patchJump(catchJump);
  }

  static Future<void> parseImportStatement(
    final BeizeCompiler compiler,
  ) async {
    if (compiler.scopeDepth != 0) {
      throw BeizeCompilationException.topLevelImports(
        compiler.moduleName,
        compiler.previousToken,
      );
    }
    compiler.consume(BeizeTokens.string);
    final String modulePath =
        compiler.resolveImportPath(compiler.previousToken.literal as String);
    final String moduleName = compiler.resolveRelativePath(modulePath);
    int moduleIndex = -1;
    for (int i = 0; i < compiler.modules.length; i += 2) {
      final int x = compiler.modules[i];
      if (compiler.constants[x] == moduleName) {
        moduleIndex = i;
      }
    }
    if (moduleIndex == -1) {
      moduleIndex = compiler.modules.length;
      final int nameIndex = compiler.makeConstant(moduleName);
      final BeizeCompiler moduleCompiler = await compiler.createModuleCompiler(
        moduleIndex,
        modulePath,
        isAsync: false,
      );
      final int functionIndex =
          compiler.makeConstant(moduleCompiler.currentFunction);
      compiler.modules.add(nameIndex);
      compiler.modules.add(functionIndex);
      await moduleCompiler.compile();
    }
    if (compiler.match(BeizeTokens.onlyKw)) {
      bool cont = true;
      while (cont && !compiler.check(BeizeTokens.semi)) {
        compiler.emitOpCode(BeizeOpCodes.opImport);
        compiler.emitCode(moduleIndex);
        compiler.consume(BeizeTokens.identifier);
        final int onlyIndex = parseIdentifierConstant(compiler);
        compiler.emitOpCode(BeizeOpCodes.opConstant);
        compiler.emitCode(onlyIndex);
        compiler.emitOpCode(BeizeOpCodes.opGetProperty);
        compiler.emitOpCode(BeizeOpCodes.opDeclare);
        compiler.emitCode(onlyIndex);
        cont = compiler.match(BeizeTokens.comma);
      }
      compiler.consume(BeizeTokens.semi);
    } else {
      compiler.emitOpCode(BeizeOpCodes.opImport);
      compiler.emitCode(moduleIndex);
      compiler.consume(BeizeTokens.asKw);
      compiler.consume(BeizeTokens.identifier);
      final int asIndex = parseIdentifierConstant(compiler);
      compiler.consume(BeizeTokens.semi);
      compiler.emitOpCode(BeizeOpCodes.opDeclare);
      compiler.emitCode(asIndex);
    }
  }

  static void parseMatchableStatement(
    final BeizeCompiler compiler,
    final void Function() matcher,
  ) {
    final List<_BeizeMatchableCase> cases = <_BeizeMatchableCase>[];
    _BeizeMatchableCase? elseCase;
    final int startJump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
    compiler.consume(BeizeTokens.braceLeft);
    while (!compiler.match(BeizeTokens.braceRight)) {
      final int start = compiler.currentAbsoluteOffset;
      if (compiler.match(BeizeTokens.elseKw)) {
        if (elseCase != null) {
          throw BeizeCompilationException.duplicateElse(
            compiler.moduleName,
            compiler.previousToken,
          );
        }
        compiler.consume(BeizeTokens.colon);
        parseStatement(compiler);
        final int exitJump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
        elseCase = (start: start, thenJump: exitJump, elseJump: -1);
      } else {
        matcher();
        compiler.consume(BeizeTokens.colon);
        final int localJump = compiler.emitJump(BeizeOpCodes.opJumpIfFalse);
        parseStatement(compiler);
        compiler.emitOpCode(BeizeOpCodes.opPop);
        final int exitJump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
        compiler.patchJump(localJump);
        compiler.emitOpCode(BeizeOpCodes.opPop);
        final int thenJump = compiler.emitJump(BeizeOpCodes.opAbsoluteJump);
        cases.add((start: start, thenJump: thenJump, elseJump: exitJump));
      }
    }
    final int end = compiler.currentAbsoluteOffset;
    for (int i = 0; i < cases.length; i++) {
      final _BeizeMatchableCase x = cases[i];
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

  static void parseWhenStatement(final BeizeCompiler compiler) {
    parseMatchableStatement(compiler, () {
      parseExpression(compiler);
    });
  }

  static void parseMatchStatement(final BeizeCompiler compiler) {
    compiler.consume(BeizeTokens.parenLeft);
    parseExpression(compiler);
    compiler.consume(BeizeTokens.parenRight);
    parseMatchableStatement(compiler, () {
      compiler.emitOpCode(BeizeOpCodes.opTop);
      parseExpression(compiler);
      compiler.emitOpCode(BeizeOpCodes.opEqual);
    });
    compiler.emitOpCode(BeizeOpCodes.opPop);
  }

  static int parseIdentifierConstant(final BeizeCompiler compiler) {
    final String name = compiler.previousToken.literal as String;
    final int index = compiler.makeConstant(name);
    return index;
  }

  static void parseExpressionStatement(final BeizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BeizeTokens.semi);
    compiler.emitOpCode(BeizeOpCodes.opPop);
  }

  static void parseExpression(final BeizeCompiler compiler) {
    parsePrecedence(compiler, BeizePrecedence.assignment);
  }

  static void parsePrecedence(
    final BeizeCompiler compiler,
    final BeizePrecedence precedence,
  ) {
    compiler.advance();
    final BeizeParseRule rule = BeizeParseRule.of(compiler.previousToken.type);
    if (rule.prefix == null) {
      throw BeizeCompilationException.expectedXButReceivedToken(
        compiler.moduleName,
        'expression',
        compiler.previousToken.type,
        compiler.previousToken.span,
      );
    }
    rule.prefix!(compiler);
    parseInfixExpression(compiler, precedence);
  }

  static void parseInfixExpression(
    final BeizeCompiler compiler,
    final BeizePrecedence precedence,
  ) {
    BeizeParseRule nextRule = BeizeParseRule.of(compiler.currentToken.type);
    while (precedence.value <= nextRule.precedence.value) {
      compiler.advance();
      nextRule.infix!(compiler);
      nextRule = BeizeParseRule.of(compiler.currentToken.type);
    }
  }

  static void parseUnaryExpression(final BeizeCompiler compiler) {
    final BeizeTokens operator = compiler.previousToken.type;
    parsePrecedence(compiler, BeizePrecedence.unary);
    switch (operator) {
      case BeizeTokens.plus:
        break;

      case BeizeTokens.minus:
        compiler.emitOpCode(BeizeOpCodes.opNegate);

      case BeizeTokens.bang:
        compiler.emitOpCode(BeizeOpCodes.opNot);

      case BeizeTokens.tilde:
        compiler.emitOpCode(BeizeOpCodes.opBitwiseNot);

      default:
        throw UnreachableException();
    }
  }

  static void parseBinaryExpression(final BeizeCompiler compiler) {
    final BeizeTokens operator = compiler.previousToken.type;
    final BeizeParseRule rule = BeizeParseRule.of(operator);
    parsePrecedence(compiler, rule.precedence.nextPrecedence);
    switch (operator) {
      case BeizeTokens.equal:
        compiler.emitOpCode(BeizeOpCodes.opEqual);

      case BeizeTokens.notEqual:
        compiler.emitOpCode(BeizeOpCodes.opEqual);
        compiler.emitOpCode(BeizeOpCodes.opNot);

      case BeizeTokens.lesserThan:
        compiler.emitOpCode(BeizeOpCodes.opLess);

      case BeizeTokens.lesserThanEqual:
        compiler.emitOpCode(BeizeOpCodes.opGreater);
        compiler.emitOpCode(BeizeOpCodes.opNot);

      case BeizeTokens.greaterThan:
        compiler.emitOpCode(BeizeOpCodes.opGreater);

      case BeizeTokens.greaterThanEqual:
        compiler.emitOpCode(BeizeOpCodes.opLess);
        compiler.emitOpCode(BeizeOpCodes.opNot);

      case BeizeTokens.plus:
        compiler.emitOpCode(BeizeOpCodes.opAdd);

      case BeizeTokens.minus:
        compiler.emitOpCode(BeizeOpCodes.opSubtract);

      case BeizeTokens.asterisk:
        compiler.emitOpCode(BeizeOpCodes.opMultiply);

      case BeizeTokens.slash:
        compiler.emitOpCode(BeizeOpCodes.opDivide);

      case BeizeTokens.floor:
        compiler.emitOpCode(BeizeOpCodes.opFloor);

      case BeizeTokens.modulo:
        compiler.emitOpCode(BeizeOpCodes.opModulo);

      case BeizeTokens.exponent:
        compiler.emitOpCode(BeizeOpCodes.opExponent);

      case BeizeTokens.ampersand:
        compiler.emitOpCode(BeizeOpCodes.opBitwiseAnd);

      case BeizeTokens.pipe:
        compiler.emitOpCode(BeizeOpCodes.opBitwiseOr);

      case BeizeTokens.caret:
        compiler.emitOpCode(BeizeOpCodes.opBitwiseXor);

      case BeizeTokens.isKw:
        compiler.emitOpCode(BeizeOpCodes.opIs);

      default:
        throw UnreachableException();
    }
  }

  static void parseNumber(final BeizeCompiler compiler) {
    compiler.emitConstant(compiler.previousToken.literal as double);
  }

  static void parseString(final BeizeCompiler compiler) {
    compiler.emitConstant(compiler.previousToken.literal as String);
  }

  static void parseBoolean(final BeizeCompiler compiler) {
    compiler.emitOpCode(
      compiler.previousToken.type == BeizeTokens.trueKw
          ? BeizeOpCodes.opTrue
          : BeizeOpCodes.opFalse,
    );
  }

  static void parseNull(final BeizeCompiler compiler) {
    compiler.emitOpCode(BeizeOpCodes.opNull);
  }

  static void parseGrouping(final BeizeCompiler compiler) {
    parseExpression(compiler);
    compiler.consume(BeizeTokens.parenRight);
  }

  static void parseIdentifier(final BeizeCompiler compiler) {
    final int index = parseIdentifierConstant(compiler);
    bool emitIndex = true;

    void emitLookup() {
      compiler.emitOpCode(BeizeOpCodes.opLookup);
      compiler.emitCode(index);
    }

    void emitAssign() {
      compiler.emitOpCode(BeizeOpCodes.opAssign);
    }

    void emitAssignAndIndex() {
      compiler.emitOpCode(BeizeOpCodes.opAssign);
      compiler.emitCode(index);
    }

    void emitExprAssign(final BeizeOpCodes opCode) {
      emitLookup();
      parsePrecedence(compiler, BeizePrecedence.assignment);
      compiler.emitOpCode(opCode);
      emitAssign();
    }

    if (compiler.match(BeizeTokens.declare)) {
      parseExpression(compiler);
      compiler.emitOpCode(BeizeOpCodes.opDeclare);
    } else if (compiler.match(BeizeTokens.assign)) {
      parseExpression(compiler);
      emitAssign();
    } else if (compiler.match(BeizeTokens.increment)) {
      emitLookup();
      compiler.emitConstant(1.0);
      compiler.emitOpCode(BeizeOpCodes.opAdd);
      emitAssign();
    } else if (compiler.match(BeizeTokens.decrement)) {
      emitLookup();
      compiler.emitConstant(1.0);
      compiler.emitOpCode(BeizeOpCodes.opSubtract);
      emitAssign();
    } else if (compiler.match(BeizeTokens.plusEqual)) {
      emitExprAssign(BeizeOpCodes.opAdd);
    } else if (compiler.match(BeizeTokens.minusEqual)) {
      emitExprAssign(BeizeOpCodes.opSubtract);
    } else if (compiler.match(BeizeTokens.asteriskEqual)) {
      emitExprAssign(BeizeOpCodes.opMultiply);
    } else if (compiler.match(BeizeTokens.exponentEqual)) {
      emitExprAssign(BeizeOpCodes.opExponent);
    } else if (compiler.match(BeizeTokens.slashEqual)) {
      emitExprAssign(BeizeOpCodes.opDivide);
    } else if (compiler.match(BeizeTokens.floorEqual)) {
      emitExprAssign(BeizeOpCodes.opFloor);
    } else if (compiler.match(BeizeTokens.moduloEqual)) {
      emitExprAssign(BeizeOpCodes.opModulo);
    } else if (compiler.match(BeizeTokens.ampersandEqual)) {
      emitExprAssign(BeizeOpCodes.opBitwiseAnd);
    } else if (compiler.match(BeizeTokens.pipeEqual)) {
      emitExprAssign(BeizeOpCodes.opBitwiseOr);
    } else if (compiler.match(BeizeTokens.caretEqual)) {
      emitExprAssign(BeizeOpCodes.opBitwiseXor);
    } else if (compiler.match(BeizeTokens.logicalAndEqual)) {
      emitIndex = false;
      emitLookup();
      parseLogicalAnd(
        compiler,
        precedence: BeizePrecedence.assignment,
        beforePatch: emitAssignAndIndex,
      );
    } else if (compiler.match(BeizeTokens.logicalOrEqual)) {
      emitIndex = false;
      emitLookup();
      parseLogicalOr(
        compiler,
        precedence: BeizePrecedence.assignment,
        beforePatch: emitAssignAndIndex,
      );
    } else if (compiler.match(BeizeTokens.nullOrEqual)) {
      emitIndex = false;
      emitLookup();
      parseNullOr(
        compiler,
        precedence: BeizePrecedence.assignment,
        beforePatch: emitAssignAndIndex,
      );
    } else {
      compiler.emitOpCode(BeizeOpCodes.opLookup);
    }
    if (emitIndex) {
      compiler.emitCode(index);
    }
  }

  static void parseLogicalAnd(
    final BeizeCompiler compiler, {
    final BeizePrecedence precedence = BeizePrecedence.and,
    final void Function()? beforePatch,
  }) {
    final int endJump = compiler.emitJump(BeizeOpCodes.opJumpIfFalse);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parsePrecedence(compiler, precedence);
    beforePatch?.call();
    compiler.patchJump(endJump);
  }

  static void parseLogicalOr(
    final BeizeCompiler compiler, {
    final BeizePrecedence precedence = BeizePrecedence.or,
    final void Function()? beforePatch,
  }) {
    final int elseJump = compiler.emitJump(BeizeOpCodes.opJumpIfFalse);
    final int endJump = compiler.emitJump(BeizeOpCodes.opJump);
    compiler.patchJump(elseJump);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parsePrecedence(compiler, precedence);
    beforePatch?.call();
    compiler.patchJump(endJump);
  }

  static void parseFunction(final BeizeCompiler compiler) {
    final bool isAsync = compiler.match(BeizeTokens.asyncKw);
    final BeizeCompiler functionCompiler =
        compiler.createFunctionCompiler(isAsync: isAsync);
    bool cont = true;
    while (cont && functionCompiler.check(BeizeTokens.identifier)) {
      functionCompiler.consume(BeizeTokens.identifier);
      final String argName = functionCompiler.previousToken.literal as String;
      final int argIndex = compiler.makeConstant(argName);
      functionCompiler.currentFunction.arguments.add(argIndex);
      cont = functionCompiler.match(BeizeTokens.comma);
    }
    if (functionCompiler.match(BeizeTokens.colon)) {
      parseExpression(functionCompiler);
      functionCompiler.emitOpCode(BeizeOpCodes.opReturn);
    } else {
      functionCompiler.match(BeizeTokens.braceLeft);
      parseBlockStatement(functionCompiler);
    }
    compiler.emitConstant(functionCompiler.currentFunction);
    compiler.copyTokenState(functionCompiler);
  }

  static void parseCall(final BeizeCompiler compiler) {
    int count = 0;
    bool cont = true;
    while (cont && !compiler.check(BeizeTokens.parenRight)) {
      parseExpression(compiler);
      count++;
      cont = compiler.match(BeizeTokens.comma);
    }
    compiler.consume(BeizeTokens.parenRight);
    compiler.emitOpCode(BeizeOpCodes.opCall);
    compiler.emitCode(count);
  }

  static void parseList(final BeizeCompiler compiler) {
    int count = 0;
    bool cont = true;
    while (cont && !compiler.check(BeizeTokens.bracketRight)) {
      parseExpression(compiler);
      count++;
      cont = compiler.match(BeizeTokens.comma);
    }
    compiler.consume(BeizeTokens.bracketRight);
    compiler.emitOpCode(BeizeOpCodes.opList);
    compiler.emitCode(count);
  }

  static void parseObject(final BeizeCompiler compiler) {
    int count = 0;
    bool cont = true;
    while (cont && !compiler.check(BeizeTokens.braceRight)) {
      if (compiler.match(BeizeTokens.bracketLeft)) {
        parseExpression(compiler);
        compiler.consume(BeizeTokens.bracketRight);
      } else {
        compiler.consume(BeizeTokens.identifier);
        final String key = compiler.previousToken.literal as String;
        compiler.emitConstant(key);
      }
      compiler.consume(BeizeTokens.colon);
      parseExpression(compiler);
      count++;
      cont = compiler.match(BeizeTokens.comma);
    }
    compiler.consume(BeizeTokens.braceRight);
    compiler.emitOpCode(BeizeOpCodes.opObject);
    compiler.emitCode(count);
  }

  static void parsePropertyCall(
    final BeizeCompiler compiler, {
    final bool dotCall = false,
  }) {
    if (dotCall && compiler.match(BeizeTokens.awaitKw)) {
      if (!compiler.currentFunction.isAsync) {
        throw BeizeCompilationException.cannotAwaitOutsideAsyncFunction(
          compiler.moduleName,
          compiler.previousToken,
        );
      }
      compiler.emitOpCode(BeizeOpCodes.opAwait);
      return;
    }
    if (dotCall) {
      compiler.consume(BeizeTokens.identifier);
      final String key = compiler.previousToken.literal as String;
      compiler.emitConstant(key);
    } else {
      parseExpression(compiler);
      compiler.consume(BeizeTokens.bracketRight);
    }
    if (compiler.match(BeizeTokens.assign)) {
      parseExpression(compiler);
      compiler.emitOpCode(BeizeOpCodes.opSetProperty);
    } else {
      compiler.emitOpCode(BeizeOpCodes.opGetProperty);
    }
  }

  static void parseDotCall(final BeizeCompiler compiler) {
    parsePropertyCall(compiler, dotCall: true);
  }

  static void parseBracketCall(final BeizeCompiler compiler) {
    parsePropertyCall(compiler);
  }

  static void parseTernary(final BeizeCompiler compiler) {
    final int thenJump = compiler.emitJump(BeizeOpCodes.opJumpIfFalse);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parseExpression(compiler);
    final int elseJump = compiler.emitJump(BeizeOpCodes.opJump);
    compiler.patchJump(thenJump);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    compiler.consume(BeizeTokens.colon);
    parseExpression(compiler);
    compiler.patchJump(elseJump);
  }

  static void parseNullOr(
    final BeizeCompiler compiler, {
    final BeizePrecedence precedence = BeizePrecedence.or,
    final void Function()? beforePatch,
  }) {
    final int elseJump = compiler.emitJump(BeizeOpCodes.opJumpIfNull);
    final int endJump = compiler.emitJump(BeizeOpCodes.opJump);
    compiler.patchJump(elseJump);
    compiler.emitOpCode(BeizeOpCodes.opPop);
    parsePrecedence(compiler, precedence);
    beforePatch?.call();
    compiler.patchJump(endJump);
  }

  static void parseNullAccess(final BeizeCompiler compiler) {
    final int exitJump = compiler.emitJump(BeizeOpCodes.opJumpIfNull);
    if (compiler.match(BeizeTokens.parenLeft)) {
      parseCall(compiler);
    } else {
      parsePropertyCall(
        compiler,
        dotCall: !compiler.match(BeizeTokens.bracketLeft),
      );
    }
    parseInfixExpression(compiler, BeizePrecedence.call);
    compiler.patchJump(exitJump);
  }

  static void parseIs(final BeizeCompiler compiler) {
    compiler.emitOpCode(BeizeOpCodes.opIs);
  }

  static void parseClass(final BeizeCompiler compiler) {
    bool hasParent = false;
    if (!compiler.check(BeizeTokens.braceLeft)) {
      parseExpression(compiler);
      hasParent = true;
    }
    // this will be in format such as
    // <total count>, <static count>, <instance count>, <static count>, ...
    final List<int> markings = <int>[];
    bool cont = true;
    compiler.consume(BeizeTokens.braceLeft);
    while (cont && !compiler.check(BeizeTokens.braceRight)) {
      final bool isStatic = compiler.match(BeizeTokens.staticKw);
      if (compiler.match(BeizeTokens.bracketLeft)) {
        parseExpression(compiler);
        compiler.consume(BeizeTokens.bracketRight);
      } else {
        compiler.consume(BeizeTokens.identifier);
        final String key = compiler.previousToken.literal as String;
        compiler.emitConstant(key);
      }
      compiler.consume(BeizeTokens.colon);
      if (isStatic) {
        parseExpression(compiler);
        markings.add(0);
      } else {
        compiler.consume(BeizeTokens.rightArrow);
        parseFunction(compiler);
        markings.add(1);
      }
      cont = compiler.match(BeizeTokens.comma);
    }
    compiler.consume(BeizeTokens.braceRight);
    compiler.emitOpCode(BeizeOpCodes.opClass);
    compiler.emitCode(hasParent ? 1 : 0);
    compiler.emitCode(markings.length);
    for (final int x in markings) {
      compiler.emitCode(x);
    }
  }
}
