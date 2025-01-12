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
        final BeizeConstant constant = program.constantAt(constantPosition);
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(constant [$constantPosition] = ${stringifyConstant(constant)})',
        );
        if (constant is BeizeFunctionConstant) {
          final List<String> argNames = constant.arguments
              .map((final int x) => '${program.constantAt(x)} (constant [$x])')
              .toList();
          output.write(
            '-> ${constant.isAsync ? 'async' : ''} ${argNames.join(', ')}',
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

      case BeizeOpCodes.opImport:
        final int moduleIndex = chunk.codeAt(ip + 1);
        final int nameIndex = program.modules[moduleIndex];
        final String moduleName = program.constantAt(nameIndex) as String;
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(module [$moduleIndex] = $moduleName)',
        );
        return 1;

      case BeizeOpCodes.opClass:
        final int hasParent = chunk.codeAt(ip + 1);
        final int count = chunk.codeAt(ip + 2);
        final List<int> markings = <int>[];
        for (int i = 1; i <= count; i++) {
          markings.add(chunk.codeAt(ip + 2 + i));
        }
        writeInstruction(
          opCode,
          ip,
          chunk.lineAt(ip),
          '{so}(hasParent = $hasParent, markings = ${markings.join(' ')})',
        );
        return 2 + count;

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
    for (int i = 0; i < program.modules.length; i += 2) {
      final int nameIndex = program.modules[i];
      final int functionIndex = program.modules[i + 1];
      final String moduleName = program.constantAt(nameIndex) as String;
      final BeizeFunctionConstant function =
          program.constantAt(functionIndex) as BeizeFunctionConstant;
      output.write(
        '> $moduleName (constant [$nameIndex]) at constant [$functionIndex] ${nameIndex == 0 ? "(entrypoint)" : ""}',
      );
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
