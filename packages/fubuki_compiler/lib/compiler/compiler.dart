import 'dart:io';
import 'package:fubuki_vm/exports.dart';
import 'package:path/path.dart' as path;
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../scanner/exports.dart';
import '../token/exports.dart';
import 'parser/exports.dart';
import 'state.dart';

enum FubukiCompilerMode {
  function,
  script,
}

class FubukiCompilerOptions {
  const FubukiCompilerOptions({
    this.shortenPositions = true,
  });

  final bool shortenPositions;

  static const FubukiCompilerOptions defaultValue = FubukiCompilerOptions();
}

class FubukiCompiler {
  FubukiCompiler._(
    this.scanner, {
    required this.mode,
    required this.root,
    required this.modules,
    required this.module,
    this.options = FubukiCompilerOptions.defaultValue,
    this.parent,
  });

  final FubukiCompiler? parent;
  final FubukiCompilerOptions options;
  final FubukiScanner scanner;
  final FubukiCompilerMode mode;
  final String root;
  final Map<String, FubukiFunctionConstant> modules;
  final String module;

  late FubukiToken previousToken;
  late FubukiToken currentToken;
  late FubukiFunctionConstant currentFunction;

  late int scopeDepth;
  late List<FubukiCompilerLoopState> loops;

  void prepare() {
    currentFunction = FubukiFunctionConstant(
      arguments: <String>[],
      chunk: FubukiChunk.empty(module),
    );
    scopeDepth = 0;
    loops = <FubukiCompilerLoopState>[];
    if (parent != null) {
      copyTokenState(parent!);
    } else {
      currentToken = scanner.readToken();
    }
  }

  FubukiCompiler createFunctionCompiler() {
    final FubukiCompiler derived = FubukiCompiler._(
      scanner,
      mode: FubukiCompilerMode.function,
      root: root,
      modules: modules,
      module: module,
      parent: this,
      options: options,
    );
    derived.prepare();
    return derived;
  }

  Future<FubukiCompiler> createModuleCompiler(final String module) async {
    final File file = File(path.join(root, module));
    final FubukiInput input = await FubukiInput.fromFile(file);
    final FubukiCompiler derived = FubukiCompiler._(
      FubukiScanner(input),
      mode: FubukiCompilerMode.script,
      root: root,
      modules: modules,
      module: module,
      options: options,
    );
    derived.prepare();
    return derived;
  }

  String resolveImportPath(final String importPath) {
    final String importDir = path.dirname(path.join(root, module));
    final String absolutePath = path.join(importDir, importPath);
    return path.relative(path.normalize(absolutePath), from: root);
  }

  Future<FubukiFunctionConstant> compile() async {
    while (!isEndOfFile()) {
      await FubukiParser.parseStatement(this);
    }
    return currentFunction;
  }

  FubukiToken advance() {
    previousToken = currentToken;
    currentToken = scanner.readToken();
    if (currentToken.type == FubukiTokens.illegal) {
      throw FubukiCompilationException.illegalToken(module, currentToken);
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
      throw FubukiCompilationException.expectedTokenButReceivedToken(
        module,
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
    final String position = options.shortenPositions
        ? previousToken.span.start.row.toString()
        : previousToken.span.toString();
    currentChunk.addCode(code, position);
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

  void patchAbsoluteJump(final int offset) {
    final int jump = currentChunk.length;
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

  static Future<FubukiProgramConstant> compileProject({
    required final String root,
    required final String entrypoint,
  }) async {
    final File file = File(path.join(root, entrypoint));
    final FubukiInput input = await FubukiInput.fromFile(file);
    final FubukiCompiler derived = FubukiCompiler._(
      FubukiScanner(input),
      mode: FubukiCompilerMode.script,
      root: root,
      modules: <String, FubukiFunctionConstant>{},
      module: entrypoint,
    );
    derived.prepare();
    // NOTE: dummy chunk
    derived.modules[entrypoint] = FubukiFunctionConstant(
      arguments: <String>[],
      chunk: FubukiChunk.empty(entrypoint),
    );
    derived.modules[entrypoint] = await derived.compile();
    return FubukiProgramConstant(
      modules: derived.modules,
      entrypoint: entrypoint,
    );
  }
}
