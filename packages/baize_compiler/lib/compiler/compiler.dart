import 'dart:io';
import 'package:path/path.dart' as path;
import '../bytecode.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../scanner/exports.dart';
import '../token/exports.dart';
import 'parser/exports.dart';
import 'state.dart';

enum BaizeCompilerMode {
  function,
  script,
}

class BaizeCompilerOptions {
  const BaizeCompilerOptions();

  static const BaizeCompilerOptions defaultValue = BaizeCompilerOptions();
}

class BaizeCompiler {
  BaizeCompiler._(
    this.scanner, {
    required this.mode,
    required this.root,
    required this.modules,
    required this.module,
    this.options = BaizeCompilerOptions.defaultValue,
    this.parent,
  });

  final BaizeCompiler? parent;
  final BaizeCompilerOptions options;
  final BaizeScanner scanner;
  final BaizeCompilerMode mode;
  final String root;
  final Map<String, BaizeFunctionConstant> modules;
  final String module;

  late BaizeToken previousToken;
  late BaizeToken currentToken;
  late BaizeFunctionConstant currentFunction;

  late int scopeDepth;
  late final List<BaizeCompilerLoopState> loops;

  void prepare({
    final bool isAsync = false,
  }) {
    currentFunction = BaizeFunctionConstant(
      arguments: <String>[],
      chunk: BaizeChunk.empty(module),
    );
    scopeDepth = 0;
    loops = <BaizeCompilerLoopState>[];
    if (parent != null) {
      copyTokenState(parent!);
    } else {
      currentToken = scanner.readToken();
    }
  }

  BaizeCompiler createFunctionCompiler() {
    final BaizeCompiler derived = BaizeCompiler._(
      scanner,
      mode: BaizeCompilerMode.function,
      root: root,
      modules: modules,
      module: module,
      parent: this,
      options: options,
    );
    derived.prepare();
    return derived;
  }

  Future<BaizeCompiler> createModuleCompiler(final String module) async {
    final File file = File(path.join(root, module));
    final BaizeInput input = await BaizeInput.fromFile(file);
    final BaizeCompiler derived = BaizeCompiler._(
      BaizeScanner(input),
      mode: BaizeCompilerMode.script,
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

  Future<BaizeFunctionConstant> compile() async {
    while (!isEndOfFile()) {
      await BaizeParser.parseStatement(this);
    }
    return currentFunction;
  }

  BaizeToken advance() {
    previousToken = currentToken;
    currentToken = scanner.readToken();
    if (currentToken.type == BaizeTokens.illegal) {
      throw BaizeCompilationException.illegalToken(module, currentToken);
    }
    return currentToken;
  }

  bool check(final BaizeTokens type) => currentToken.type == type;

  bool match(final BaizeTokens type) {
    if (!check(type)) return false;
    advance();
    return true;
  }

  void ensure(final BaizeTokens type) {
    if (!check(type)) {
      throw BaizeCompilationException.expectedTokenButReceivedToken(
        module,
        type,
        currentToken.type,
        currentToken.span,
      );
    }
  }

  void consume(final BaizeTokens type) {
    ensure(type);
    advance();
  }

  void emitCode(final int code) {
    currentChunk.addCode(code, previousToken.span.start.row + 1);
  }

  void emitOpCode(final BaizeOpCodes opCode) => emitCode(opCode.index);

  void emitConstant(final BaizeConstant value) {
    emitOpCode(BaizeOpCodes.opConstant);
    emitCode(makeConstant(value));
  }

  int makeConstant(final BaizeConstant value) =>
      currentChunk.addConstant(value);

  int emitJump(final BaizeOpCodes opCode) {
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

  void patchAbsoluteJumpTo(final int offset, final int to) {
    currentChunk.codes[offset] = to;
  }

  void beginLoop(final int start) {
    final int endJump = emitJump(BaizeOpCodes.opJumpIfFalse);
    final BaizeCompilerLoopState loop = BaizeCompilerLoopState(
      scopeDepth: scopeDepth,
      start: start,
      endJump: endJump,
    );
    loops.add(loop);
  }

  void endLoop() {
    final BaizeCompilerLoopState loop = loops.removeLast();
    patchJump(loop.endJump);
    emitOpCode(BaizeOpCodes.opPop);
    loop.exitJumps.forEach(patchJump);
  }

  void endLoopScope() {
    final int count = scopeDepth - loops.last.scopeDepth;
    for (int i = 0; i < count; i++) {
      emitOpCode(BaizeOpCodes.opEndScope);
    }
  }

  void emitBreak() {
    endLoopScope();
    final int offset = emitJump(BaizeOpCodes.opJump);
    loops.last.exitJumps.add(offset);
  }

  void emitContinue() {
    final int jump = emitJump(BaizeOpCodes.opAbsoluteJump);
    patchAbsoluteJumpTo(jump, loops.last.start);
  }

  void beginScope() {
    scopeDepth++;
  }

  void endScope() {
    scopeDepth--;
  }

  void copyTokenState(final BaizeCompiler compiler) {
    previousToken = compiler.previousToken;
    currentToken = compiler.currentToken;
  }

  bool isEndOfFile() => currentToken.type == BaizeTokens.eof;

  BaizeChunk get currentChunk => currentFunction.chunk;

  int get currentAbsoluteOffset => currentChunk.length;

  static Future<BaizeProgramConstant> compileProject({
    required final String root,
    required final String entrypoint,
  }) async {
    final File file = File(path.join(root, entrypoint));
    final BaizeInput input = await BaizeInput.fromFile(file);
    final BaizeCompiler derived = BaizeCompiler._(
      BaizeScanner(input),
      mode: BaizeCompilerMode.script,
      root: root,
      modules: <String, BaizeFunctionConstant>{},
      module: entrypoint,
    );
    derived.prepare();
    // NOTE: dummy chunk
    derived.modules[entrypoint] = BaizeFunctionConstant(
      arguments: <String>[],
      chunk: BaizeChunk.empty(entrypoint),
    );
    derived.modules[entrypoint] = await derived.compile();
    return BaizeProgramConstant(
      modules: derived.modules,
      entrypoint: entrypoint,
    );
  }
}
