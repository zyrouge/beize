import 'dart:io';
import 'package:path/path.dart' as p;
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
  BeizeCompilerOptions({
    this.disablePrint = false,
  });

  final bool disablePrint;
}

class BeizeCompiler {
  BeizeCompiler._(
    this.scanner, {
    required this.mode,
    required this.root,
    required this.moduleId,
    required this.moduleNames,
    required this.modules,
    required this.options,
    this.parent,
  });

  final BeizeCompiler? parent;
  final BeizeCompilerOptions options;
  final BeizeScanner scanner;
  final BeizeCompilerMode mode;
  final String root;
  final int moduleId;
  final List<String> moduleNames;
  final List<BeizeFunctionConstant> modules;

  late BeizeToken previousToken;
  late BeizeToken currentToken;
  late BeizeFunctionConstant currentFunction;

  late int scopeDepth;
  late final List<BeizeCompilerLoopState> loops;

  void prepare({
    required final bool isAsync,
  }) {
    currentFunction = BeizeFunctionConstant(
      isAsync: isAsync,
      arguments: <String>[],
      chunk: BeizeChunk.empty(moduleId),
    );
    scopeDepth = 0;
    loops = <BeizeCompilerLoopState>[];
    if (parent != null) {
      copyTokenState(parent!);
    } else {
      currentToken = scanner.readToken();
    }
  }

  BeizeCompiler createFunctionCompiler({
    required final bool isAsync,
  }) {
    final BeizeCompiler derived = BeizeCompiler._(
      scanner,
      mode: BeizeCompilerMode.function,
      root: root,
      moduleId: moduleId,
      moduleNames: moduleNames,
      modules: modules,
      parent: this,
      options: options,
    );
    derived.prepare(isAsync: isAsync);
    return derived;
  }

  Future<BeizeCompiler> createModuleCompiler(
    final int moduleId,
    final String path, {
    required final bool isAsync,
  }) async {
    final File file = File(p.join(root, path));
    final BeizeInput input = await BeizeInput.fromFile(file);
    final BeizeCompiler derived = BeizeCompiler._(
      BeizeScanner(input),
      mode: BeizeCompilerMode.script,
      root: root,
      moduleId: moduleId,
      moduleNames: moduleNames,
      modules: modules,
      options: options,
    );
    derived.prepare(isAsync: isAsync);
    return derived;
  }

  String resolveImportPath(final String path) {
    final String importDir = p.dirname(p.join(root, moduleName));
    final String absolutePath = p.join(importDir, path);
    return p.relative(p.normalize(absolutePath), from: root);
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
      throw BeizeCompilationException.illegalToken(
        moduleName,
        currentToken,
      );
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
        moduleName,
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

  String get moduleName => moduleNames[moduleId];

  BeizeChunk get currentChunk => currentFunction.chunk;

  int get currentAbsoluteOffset => currentChunk.length;

  static Future<BeizeProgramConstant> compileProject({
    required final String root,
    required final String entrypoint,
    required final BeizeCompilerOptions options,
  }) async {
    final String fullPath = p.join(root, entrypoint);
    final File file = File(fullPath);
    final BeizeInput input = await BeizeInput.fromFile(file);
    final BeizeCompiler compiler = BeizeCompiler._(
      BeizeScanner(input),
      mode: BeizeCompilerMode.script,
      root: root,
      options: options,
      moduleId: 0,
      moduleNames: <String>[],
      modules: <BeizeFunctionConstant>[],
    );
    compiler.prepare(isAsync: true);
    compiler.moduleNames.add(p.relative(fullPath, from: root));
    compiler.modules.add(compiler.currentFunction);
    await compiler.compile();
    return BeizeProgramConstant(
      moduleNames: compiler.moduleNames,
      modules: compiler.modules,
    );
  }
}
