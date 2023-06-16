import 'dart:io';
import 'package:beize_compiler/beize_compiler.dart';
import 'package:beize_vm/beize_vm.dart';
import 'package:path/path.dart' as p;

final String testsDir = p.join(Directory.current.path, 'tests');

Future<BeizeProgramConstant> compileTestScript(
  final String dir,
  final String scriptName,
) async {
  final BeizeProgramConstant program = await BeizeCompiler.compileProject(
    root: p.join(testsDir, dir),
    entrypoint: scriptName,
  );
  return program;
}

Future<List<String>> executeTestScript(
  final BeizeProgramConstant program,
) async {
  final BeizeVM vm = BeizeVM(program, BeizeVMOptions());
  final List<String> output = <String>[];
  final BeizeNativeFunctionValue out = BeizeNativeFunctionValue.sync(
    (final BeizeNativeFunctionCall call) {
      final BeizeStringValue value = call.argumentAt(0).cast();
      output.add(value.value);
      return BeizeNullValue.value;
    },
  );
  vm.globalNamespace.declare('out', out);
  await vm.run();
  return output;
}

BeizeChunk extractChunk(
  final BeizeProgramConstant program,
) {
  final BeizeChunk chunk = program.modules[program.entrypoint]!.chunk;
  return chunk;
}

class BeizeTestChunk {
  final BeizeChunk chunk = BeizeChunk.empty('testChunk');

  void addOpCode(final BeizeOpCodes opCode) {
    chunk.addOpCode(opCode, 0);
  }

  void addCode(final int code) {
    chunk.addCode(code, 0);
  }

  void addConstant(final int code, final BeizeConstant constant) {
    int missingCount = code - chunk.constants.length + 1;
    while (missingCount > 0) {
      chunk.constants.add(null);
      missingCount--;
    }
    chunk.constants[code] = constant;
    addCode(code);
  }

  List<int> get codes => chunk.codes;
  List<BeizeConstant> get constants => chunk.constants;
}

String buildExpectedChunkCode(
  final BeizeChunk chunk, {
  final String variableName = 'expectedChunk',
  final StringBuffer? buffer,
}) {
  final StringBuffer output = buffer ?? StringBuffer();
  output.writeln('final BeizeTestChunk $variableName = BeizeTestChunk();');
  int constantVariableCount = 0;
  int ip = 0;
  while (ip < chunk.codes.length) {
    final BeizeOpCodes opCode = chunk.opCodeAt(ip);
    int bump = 1;
    output.writeln('$variableName.addOpCode(BeizeOpCodes.${opCode.name});');
    switch (opCode) {
      case BeizeOpCodes.opConstant:
      case BeizeOpCodes.opDeclare:
      case BeizeOpCodes.opAssign:
      case BeizeOpCodes.opLookup:
        final int constantPosition = chunk.codeAt(ip + 1);
        final BeizeConstant constant = chunk.constantAt(constantPosition);
        if (constant is BeizeFunctionConstant) {
          final String constantVariableName =
              '${variableName}_$constantVariableCount';
          buildExpectedChunkCode(
            constant.chunk,
            variableName: constantVariableName,
            buffer: output,
          );
          output.writeln(
            '$variableName.addConstant($constantPosition, $constantVariableName);',
          );
          constantVariableCount++;
        } else if (constant is double) {
          output.writeln(
            '$variableName.addConstant($constantPosition, $constant);',
          );
        } else if (constant is String) {
          output.writeln(
            "$variableName.addConstant($constantPosition, '${escapedString(constant, "'")}');",
          );
        }
        bump++;
        break;

      case BeizeOpCodes.opJump:
      case BeizeOpCodes.opJumpIfFalse:
      case BeizeOpCodes.opJumpIfNull:
      case BeizeOpCodes.opAbsoluteJump:
      case BeizeOpCodes.opBeginTry:
      case BeizeOpCodes.opCall:
      case BeizeOpCodes.opList:
      case BeizeOpCodes.opObject:
        final int value = chunk.codeAt(ip + 1);
        output.writeln('$variableName.addCode($value);');
        bump++;
        break;

      case BeizeOpCodes.opModule:
        final int pathPosition = chunk.codeAt(ip + 1);
        final int identifierPosition = chunk.codeAt(ip + 2);
        final String path = chunk.constantAt(pathPosition) as String;
        final String identifier =
            chunk.constantAt(identifierPosition) as String;
        output.writeln(
          "$variableName.addConstant($pathPosition, '${escapedString(path, "'")}');",
        );
        output.writeln(
          "$variableName.addConstant($identifierPosition, '$identifier');",
        );
        bump += 2;
        break;

      default:
    }
    ip += bump;
  }
  return output.toString().trim();
}

void printExpectedChunkCode(final BeizeChunk chunk) {
  // ignore: avoid_print
  print(buildExpectedChunkCode(chunk));
}

String escapedString(final String value, final String char) =>
    value.replaceAll(char, '\\$char');

typedef BeizeTestComparableProgram = Map<String, dynamic>;

// (transpile to) Test-Comparable-Program (from) (Beize)-Chunk
BeizeTestComparableProgram tcpc(final BeizeChunk chunk) =>
    transpileTestComparableProgram(chunk.codes, chunk.constants);

// (transpile to) Test-Comparable-Program (from) (Beize)-Test-Chunk
BeizeTestComparableProgram tcptc(final BeizeTestChunk chunk) =>
    transpileTestComparableProgram(chunk.codes, chunk.constants);

BeizeTestComparableProgram transpileTestComparableProgram(
  final List<int> codes,
  final List<BeizeConstant> constants,
) {
  final List<dynamic> transpiledConstants = <dynamic>[];
  for (final BeizeConstant x in constants) {
    if (x is BeizeFunctionConstant) {
      transpiledConstants.add(
        transpileTestComparableProgram(x.chunk.codes, x.chunk.constants),
      );
    } else if (x is BeizeTestChunk) {
      transpiledConstants.add(
        transpileTestComparableProgram(x.chunk.codes, x.chunk.constants),
      );
    } else {
      transpiledConstants.add(x);
    }
  }
  return <String, dynamic>{
    'codes': codes,
    'constants': transpiledConstants,
  };
}
