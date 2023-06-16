import 'dart:io';
import 'package:path/path.dart' as path;
import '../bytecode.dart';
import '../errors/exports.dart';
import '../lexer/exports.dart';
import '../scanner/exports.dart';
import '../token/exports.dart';
import 'parser/exports.dart';
import 'state.dart';

enum BeizeCompilerMode {
  function,
  script,
}

class BeizeCompilerOptions {
  const BeizeCompilerOptions();

  static const BeizeCompilerOptions defaultValue = BeizeCompilerOptions();
}

class BeizeCompiler {
  BeizeCompiler._(
    this.scanner, {
    required this.mode,
    required this.root,
    required this.modules,
    required this.module,
    this.options = BeizeCompilerOptions.defaultValue,
    this.parent,
  });

  final BeizeCompiler? parent;
  final BeizeCompilerOptions options;
  final BeizeScanner scanner;
  final BeizeCompilerMode mode;
  final String root;
  final Map<String, BeizeFunctionConstant> modules;
  final String module;

  late BeizeToken previousToken;
  late BeizeToken currentToken;
  late BeizeFunctionConstant currentFunction;

  late int scopeDepth;
  late final List<BeizeCompilerLoopState> loops;

  void prepare({
    final bool isAsync = false,
  }) {
    currentFunction = BeizeFunctionConstant(
      arguments: <String>[],
      chunk: BeizeChunk.empty(module),
    );
    scopeDepth = 0;
    loops = <BeizeCompilerLoopState>[];
    if (parent != null) {
      copyTokenState(parent!);
    } else {
      currentToken = scanner.readToken();
    }
  }

  BeizeCompiler createFunctionCompiler() {
    final BeizeCompiler derived = BeizeCompiler._(
      scanner,
      mode: BeizeCompilerMode.function,
      root: root,
      modules: modules,
      module: module,
      parent: this,
      options: options,
    );
    derived.prepare();
    return derived;
  }

  Future<BeizeCompiler> createModuleCompiler(final String module) async {
    final File file = File(path.join(root, module));
    final BeizeInput input = await BeizeInput.fromFile(file);
    final BeizeCompiler derived = BeizeCompiler._(
      BeizeScanner(input),
      mode: BeizeCompilerMode.script,
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

  Future<BeizeFunctionConstant> compile() async {
    while (!isEndOfFile()) {
      await BeizeParser.parseStatement(this);
    }
    return currentFunction;
  }

  BeizeToken advance() {
    previousToken = currentToken;
    currentToken = scanner.readToken();
    if (currentToken.type == BeizeTokens.illegal) {
      throw BeizeCompilationException.illegalToken(module, currentToken);
    }
    return currentToken;
  }

  bool check(final BeizeTokens type) => currentToken.type == type;

  bool match(final BeizeTokens type) {
    if (!check(type)) return false;
    advance();
    return true;
  }

  void ensure(final BeizeTokens type) {
    if (!check(type)) {
      throw BeizeCompilationException.expectedTokenButReceivedToken(
        module,
        type,
        currentToken.type,
        currentToken.span,
      );
    }
  }

  void consume(final BeizeTokens type) {
    ensure(type);
    advance();
  }

  void emitCode(final int code) {
    currentChunk.addCode(code, previousToken.span.start.row + 1);
  }

  void emitOpCode(final BeizeOpCodes opCode) => emitCode(opCode.index);

  void emitConstant(final BeizeConstant value) {
    emitOpCode(BeizeOpCodes.opConstant);
    emitCode(makeConstant(value));
  }

  int makeConstant(final BeizeConstant value) =>
      currentChunk.addConstant(value);

  int emitJump(final BeizeOpCodes opCode) {
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
    final int endJump = emitJump(BeizeOpCodes.opJumpIfFalse);
    final BeizeCompilerLoopState loop = BeizeCompilerLoopState(
      scopeDepth: scopeDepth,
      start: start,
      endJump: endJump,
    );
    loops.add(loop);
  }

  void endLoop() {
    final BeizeCompilerLoopState loop = loops.removeLast();
    patchJump(loop.endJump);
    emitOpCode(BeizeOpCodes.opPop);
    loop.exitJumps.forEach(patchJump);
  }

  void endLoopScope() {
    final int count = scopeDepth - loops.last.scopeDepth;
    for (int i = 0; i < count; i++) {
      emitOpCode(BeizeOpCodes.opEndScope);
    }
  }

  void emitBreak() {
    endLoopScope();
    final int offset = emitJump(BeizeOpCodes.opJump);
    loops.last.exitJumps.add(offset);
  }

  void emitContinue() {
    final int jump = emitJump(BeizeOpCodes.opAbsoluteJump);
    patchAbsoluteJumpTo(jump, loops.last.start);
  }

  void beginScope() {
    scopeDepth++;
  }

  void endScope() {
    scopeDepth--;
  }

  void copyTokenState(final BeizeCompiler compiler) {
    previousToken = compiler.previousToken;
    currentToken = compiler.currentToken;
  }

  bool isEndOfFile() => currentToken.type == BeizeTokens.eof;

  BeizeChunk get currentChunk => currentFunction.chunk;

  int get currentAbsoluteOffset => currentChunk.length;

  static Future<BeizeProgramConstant> compileProject({
    required final String root,
    required final String entrypoint,
  }) async {
    final File file = File(path.join(root, entrypoint));
    final BeizeInput input = await BeizeInput.fromFile(file);
    final BeizeCompiler derived = BeizeCompiler._(
      BeizeScanner(input),
      mode: BeizeCompilerMode.script,
      root: root,
      modules: <String, BeizeFunctionConstant>{},
      module: entrypoint,
    );
    derived.prepare();
    // NOTE: dummy chunk
    derived.modules[entrypoint] = BeizeFunctionConstant(
      arguments: <String>[],
      chunk: BeizeChunk.empty(entrypoint),
    );
    derived.modules[entrypoint] = await derived.compile();
    return BeizeProgramConstant(
      modules: derived.modules,
      entrypoint: entrypoint,
    );
  }
}
