import 'package:beize_shared/beize_shared.dart';
import 'output.dart';

class BeizeDisassembler {
  BeizeDisassembler(this.program, this.chunk, this.output);

  final BeizeProgramConstant program;
  final BeizeChunk chunk;
  final BeizeDisassemblerOutput output;

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
    final BeizeOpCodes opCode = chunk.opCodeAt(ip);
    switch (opCode) {
      case BeizeOpCodes.opConstant:
      case BeizeOpCodes.opDeclare:
      case BeizeOpCodes.opAssign:
      case BeizeOpCodes.opLookup:
        final int constantPosition = chunk.codeAt(ip + 1);
        final BeizeConstant constant = chunk.constantAt(constantPosition);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(constant [$constantPosition] = ${stringifyConstant(constant)})',
        );
        if (constant is BeizeFunctionConstant) {
          output.write(
            '-> ${constant.isAsync ? 'async' : ''} ${constant.arguments.join(', ')}',
          );
          BeizeDisassembler(program, constant.chunk, output.nested)
              .dissassemble(printHeader: false);
          output.write('<-');
        }
        return 1;

      case BeizeOpCodes.opJump:
      case BeizeOpCodes.opJumpIfFalse:
      case BeizeOpCodes.opJumpIfNull:
        final int offset = chunk.codeAt(ip + 1);
        final int absoluteOffset = ip + offset;
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(offset = $offset, absoluteOffset = $absoluteOffset)',
        );
        return 1;

      case BeizeOpCodes.opAbsoluteJump:
      case BeizeOpCodes.opBeginTry:
        final int offset = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(absoluteOffset = $offset)',
        );
        return 1;

      case BeizeOpCodes.opCall:
      case BeizeOpCodes.opList:
      case BeizeOpCodes.opObject:
        final int popCount = chunk.codeAt(ip + 1);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(popCount = $popCount)',
        );
        return 1;

      case BeizeOpCodes.opModule:
        final int moduleId = chunk.codeAt(ip + 1);
        final int identifierPosition = chunk.codeAt(ip + 2);
        final BeizeConstant moduleName = program.moduleNameAt(moduleId);
        final BeizeConstant identifier = chunk.constantAt(identifierPosition);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(module [$moduleId] = $moduleName, identifier [$identifierPosition] = $identifier)',
        );
        return 2;

      default:
        writeInstruction(opCode, ip, chunk.lineAt(ip));
        return 0;
    }
  }

  void writeInstruction(
    final BeizeOpCodes opCode,
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

  static void disassembleProgram(final BeizeProgramConstant program) {
    final BeizeDisassemblerOutput output = BeizeDisassemblerConsoleOutput();
    for (int i = 0; i < program.modules.length; i++) {
      final String moduleName = program.moduleNameAt(i);
      final BeizeFunctionConstant function = program.moduleAt(i);
      output.write('> $moduleName ${i == 0 ? "(entrypoint)" : ""}');
      final BeizeDisassembler disassembler =
          BeizeDisassembler(program, function.chunk, output);
      disassembler.dissassemble();
      output.write('---');
    }
  }

  static String stringifyConstant(final BeizeConstant constant) {
    if (constant is BeizeFunctionConstant) return '<function>';
    return constant.toString();
  }
}