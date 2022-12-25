import 'package:fubuki_vm/exports.dart';
import '../errors/exports.dart';
import '../scanner/exports.dart';
import '../token/exports.dart';
import 'parser/exports.dart';
import 'state.dart';

enum FubukiCompilerMode {
  function,
  script,
}

class FubukiCompiler {
  FubukiCompiler(
    this.scanner, {
    required this.mode,
  });

  final FubukiScanner scanner;
  final FubukiCompilerMode mode;

  late FubukiToken previousToken;
  late FubukiToken currentToken;
  late FubukiFunctionConstant currentFunction;

  late int scopeDepth;
  late List<FubukiCompilerLoopState> loops;

  void prepare({
    final bool updateCurrentToken = true,
  }) {
    currentFunction = FubukiFunctionConstant(
      arguments: <String>[],
      chunk: FubukiChunk.empty(),
    );
    scopeDepth = 0;
    loops = <FubukiCompilerLoopState>[];
    if (updateCurrentToken) {
      currentToken = scanner.readToken();
    }
  }

  FubukiFunctionConstant compile() {
    while (!isEndOfFile()) {
      FubukiParser.parseStatement(this);
    }
    return currentFunction;
  }

  FubukiToken advance() {
    previousToken = currentToken;
    currentToken = scanner.readToken();
    if (currentToken.type == FubukiTokens.illegal) {
      // TODO: dont throw
      throw FubukiIllegalExpressionError.illegalToken(currentToken);
    }
    return currentToken;
  }

  bool check(final FubukiTokens type) => currentToken.type == type;

  bool match(final FubukiTokens type) {
    if (!check(type)) return false;
    advance();
    return true;
  }

  void ensure(final FubukiTokens type) {
    if (!check(type)) {
      // TODO: dont throw
      throw FubukiIllegalExpressionError.expectedTokenButReceivedToken(
        type,
        currentToken.type,
        currentToken.span,
      );
    }
  }

  void consume(final FubukiTokens type) {
    ensure(type);
    advance();
  }

  void emitCode(final int code) {
    currentChunk.addCode(code, previousToken.span.toString());
  }

  void emitOpCode(final FubukiOpCodes opCode) => emitCode(opCode.index);

  void emitConstant(final FubukiConstant value) {
    emitOpCode(FubukiOpCodes.opConstant);
    emitCode(makeConstant(value));
  }

  int makeConstant(final FubukiConstant value) =>
      currentChunk.addConstant(value);

  int emitJump(final FubukiOpCodes opCode) {
    emitOpCode(opCode);
    emitCode(-1);
    return currentChunk.length - 1;
  }

  void patchJump(final int offset) {
    final int jump = currentChunk.length - offset - 1;
    currentChunk.codes[offset] = jump;
  }

  void emitLoop(final int start) {
    emitOpCode(FubukiOpCodes.opLoop);
    final int offset = currentChunk.length - start - 1;
    emitCode(offset);
  }

  void beginLoop(final int start) {
    final FubukiCompilerLoopState loop = FubukiCompilerLoopState(
      scopeDepth: scopeDepth,
      start: start,
    );
    loops.add(loop);
    final int exitJump = emitJump(FubukiOpCodes.opJumpIfFalse);
    loop.exitJumps.add(exitJump);
  }

  void endLoop() {
    final FubukiCompilerLoopState loop = loops.removeLast();
    loop.exitJumps.forEach(patchJump);
  }

  void endLoopScope() {
    final int count = scopeDepth - loops.last.scopeDepth;
    for (int i = 0; i < count; i++) {
      emitOpCode(FubukiOpCodes.opEndScope);
    }
  }

  void emitBreak() {
    endLoopScope();
    final int offset = emitJump(FubukiOpCodes.opJump);
    loops.last.exitJumps.add(offset);
  }

  void emitContinue() {
    if (loops.isEmpty) {
      throw Exception('No loops bro');
    }
    emitLoop(loops.last.start);
  }

  void beginScope() {
    scopeDepth++;
  }

  void endScope() {
    scopeDepth--;
  }

  void copyTokenState(final FubukiCompiler compiler) {
    previousToken = compiler.previousToken;
    currentToken = compiler.currentToken;
  }

  bool isEndOfFile() => currentToken.type == FubukiTokens.eof;

  FubukiChunk get currentChunk => currentFunction.chunk;
}
