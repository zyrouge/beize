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
        final BaizeConstant constant = chunk.constantAt(chunk.codeAt(ip + 1));
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(constant = ${stringifyConstant(constant)})',
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
      case BaizeOpCodes.opAbsoluteJump:
      case BaizeOpCodes.opCall:
      case BaizeOpCodes.opList:
      case BaizeOpCodes.opObject:
      case BaizeOpCodes.opBeginTry:
        final int offset = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(offset = $offset)',
        );
        return 1;

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
