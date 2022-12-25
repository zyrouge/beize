import 'package:fubuki_vm/exports.dart';
import 'output.dart';

class FubukiDisassembler {
  FubukiDisassembler(this.chunk, this.output);

  final FubukiChunk chunk;
  final FubukiDisassemblerOutput output;

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
    final FubukiOpCodes opCode = chunk.opCodeAt(ip);
    switch (opCode) {
      case FubukiOpCodes.opConstant:
      case FubukiOpCodes.opDeclare:
      case FubukiOpCodes.opAssign:
      case FubukiOpCodes.opLookup:
        final FubukiConstant constant = chunk.constantAt(chunk.codeAt(ip + 1));
        writeInstruction(
          opCode,
          ip,
          chunk.positionAt(ip),
          '{so}(constant = ${stringifyConstant(constant)})',
        );
        if (constant is FubukiFunctionConstant) {
          output.write('->');
          FubukiDisassembler(constant.chunk, output.nested)
              .dissassemble(printHeader: false);
          output.write('<-');
        }
        return 1;

      case FubukiOpCodes.opJump:
      case FubukiOpCodes.opJumpIfFalse:
      case FubukiOpCodes.opLoop:
      case FubukiOpCodes.opCall:
      case FubukiOpCodes.opList:
      case FubukiOpCodes.opObject:
        final int offset = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.positionAt(ip),
          '{so}(offset = $offset)',
        );
        return 1;

      default:
        writeInstruction(opCode, ip, chunk.positionAt(ip));
        return 0;
    }
  }

  void writeInstruction(
    final FubukiOpCodes opCode,
    final int offset,
    final String position, [
    final String extra = '',
  ]) {
    write('$offset{s}${opCode.name}{s}${chunk.positionAt(ip)}$extra');
  }

  void write(final String text) {
    output.write(text.replaceAll('{s}', _space).replaceAll('{so}', _spaceOnly));
  }

  static const String _space = '  |  ';
  static const String _spaceOnly = '  ';

  static void printDissassembled(final FubukiFunctionConstant program) {
    final FubukiDisassembler disassembler =
        FubukiDisassembler(program.chunk, FubukiDisassemblerConsoleOutput());
    disassembler.dissassemble();
  }

  static String stringifyConstant(final FubukiConstant constant) {
    if (constant is FubukiFunctionConstant) return '<function>';
    return constant.toString();
  }
}
