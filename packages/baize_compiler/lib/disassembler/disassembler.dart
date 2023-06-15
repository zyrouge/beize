import 'package:baize_shared/baize_shared.dart';
import 'output.dart';

class BaizeDisassembler {
  BaizeDisassembler(this.chunk, this.output);

  final BaizeChunk chunk;
  final BaizeDisassemblerOutput output;

  int ip = 0;

  void dissassemble({
    final bool printHeader = true,
  }) {
    if (printHeader) {
      write('Offset{s}OpCode{s}Position');
    }
    while (ip < chunk.length) {
      ip += dissassembleInstruction();
      ip++;
    }
  }

  int dissassembleInstruction() {
    final BaizeOpCodes opCode = chunk.opCodeAt(ip);
    switch (opCode) {
      case BaizeOpCodes.opConstant:
      case BaizeOpCodes.opDeclare:
      case BaizeOpCodes.opAssign:
      case BaizeOpCodes.opLookup:
        final int constantPosition = chunk.codeAt(ip + 1);
        final BaizeConstant constant = chunk.constantAt(constantPosition);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(constant [$constantPosition] = ${stringifyConstant(constant)})',
        );
        if (constant is BaizeFunctionConstant) {
          output.write('-> (${constant.arguments.join(', ')})');
          BaizeDisassembler(constant.chunk, output.nested)
              .dissassemble(printHeader: false);
          output.write('<-');
        }
        return 1;

      case BaizeOpCodes.opJump:
      case BaizeOpCodes.opJumpIfFalse:
      case BaizeOpCodes.opJumpIfNull:
        final int offset = chunk.codeAt(ip + 1);
        final int absoluteOffset = ip + offset;
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(offset = $offset, absoluteOffset = $absoluteOffset)',
        );
        return 1;

      case BaizeOpCodes.opAbsoluteJump:
      case BaizeOpCodes.opBeginTry:
        final int offset = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(absoluteOffset = $offset)',
        );
        return 1;

      case BaizeOpCodes.opCall:
      case BaizeOpCodes.opList:
      case BaizeOpCodes.opObject:
        final int popCount = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(popCount = $popCount)',
        );
        return 1;

      case BaizeOpCodes.opModule:
        final int pathPosition = chunk.codeAt(ip + 1);
        final int identifierPosition = chunk.codeAt(ip + 2);
        final BaizeConstant path = chunk.constantAt(pathPosition);
        final BaizeConstant identifier = chunk.constantAt(identifierPosition);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(path [$pathPosition] = $path, identifier [$identifierPosition] = $identifier)',
        );
        return 2;

      default:
        writeInstruction(opCode, ip, chunk.lineAt(ip));
        return 0;
    }
  }

  void writeInstruction(
    final BaizeOpCodes opCode,
    final int offset,
    final int position, [
    final String extra = '',
  ]) {
    write('$offset{s}${opCode.name}{s}$position$extra');
  }

  void write(final String text) {
    output.write(text.replaceAll('{s}', _space).replaceAll('{so}', _spaceOnly));
  }

  static const String _space = '  |  ';
  static const String _spaceOnly = '  ';

  static void disassembleProgram(final BaizeProgramConstant program) {
    final BaizeDisassemblerOutput output = BaizeDisassemblerConsoleOutput();
    for (final String x in program.modules.keys) {
      output.write('> $x ${program.entrypoint == x ? "(entrypoint)" : ""}');
      final BaizeDisassembler disassembler =
          BaizeDisassembler(program.modules[x]!.chunk, output);
      disassembler.dissassemble();
      output.write('---');
    }
  }

  static String stringifyConstant(final BaizeConstant constant) {
    if (constant is BaizeFunctionConstant) return '<function>';
    return constant.toString();
  }
}
