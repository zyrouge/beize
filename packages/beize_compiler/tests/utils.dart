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
    options: BeizeCompilerOptions(),
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

class BeizeTestProgram {
  final List<int> modules = <int>[];
  final List<BeizeConstant> constants = <BeizeConstant>[];

  BeizeTestChunk addModule(
    final int moduleIndex,
    final int moduleNameIndex,
    final String moduleName,
    final int functionIndex,
  ) {
    int missingCount = moduleIndex - modules.length + 1;
    while (missingCount > 0) {
      modules.add(0);
      missingCount--;
    }
    modules[moduleIndex] = moduleNameIndex;
    final BeizeTestChunk chunk = BeizeTestChunk(
      this,
      BeizeChunk.empty(moduleIndex),
    );
    addConstant(moduleNameIndex, moduleName);
    addConstant(
      functionIndex,
      BeizeFunctionConstant(
        isAsync: true,
        arguments: <int>[],
        chunk: chunk.chunk,
      ),
    );
    return chunk;
  }

  void addConstant(final int code, final BeizeConstant constant) {
    int missingCount = code - constants.length + 1;
    while (missingCount > 0) {
      constants.add(null);
      missingCount--;
    }
    constants[code] = constant;
  }
}

class BeizeTestChunk {
  BeizeTestChunk(this.program, this.chunk);

  final BeizeTestProgram program;
  final BeizeChunk chunk;

  void addOpCode(final BeizeOpCodes opCode) {
    chunk.addOpCode(opCode, 0);
  }

  void addCode(final int code) {
    chunk.addCode(code, 0);
  }

  void addConstant(final int code, final BeizeConstant constant) {
    program.addConstant(code, constant);
    addCode(code);
  }

  List<int> get codes => chunk.codes;
}

String buildExpectedProgramCode(
  final BeizeProgramConstant program, {
  final StringBuffer? buffer,
}) {
  final StringBuffer output = buffer ?? StringBuffer();
  output.write('final BeizeTestProgram expectedProgram = BeizeTestProgram();');
  for (int i = 0; i < program.modules.length; i++) {
    final int moduleNameIndex = program.modules[i];
    final int functionIndex = program.modules[i + 1];
    final String moduleName = program.constantAt(moduleNameIndex) as String;
    final BeizeFunctionConstant function =
        program.constantAt(functionIndex) as BeizeFunctionConstant;
    final String variableName = 'expectedModule$i';
    output.write(
      "final BeizeTestChunk $variableName = expectedProgram.addModule($i, $moduleNameIndex, '${escapedString(moduleName, "'")}', $functionIndex);",
    );
    buildExpectedChunkCode(
      program,
      function.chunk,
      variableExists: true,
      variableName: variableName,
      buffer: output,
    );
  }
  return output.toString().trim();
}

String buildExpectedChunkCode(
  final BeizeProgramConstant program,
  final BeizeChunk chunk, {
  final bool variableExists = false,
  final String variableName = 'expectedChunk',
  final StringBuffer? buffer,
}) {
  final StringBuffer output = buffer ?? StringBuffer();
  if (!variableExists) {
    output.writeln('final BeizeTestChunk $variableName = BeizeTestChunk();');
  }
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
        final BeizeConstant constant = program.constantAt(constantPosition);
        if (constant is BeizeFunctionConstant) {
          final String constantVariableName =
              '${variableName}_$constantVariableCount';
          buildExpectedChunkCode(
            program,
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

      case BeizeOpCodes.opImport:
        final int moduleIndex = chunk.codeAt(ip + 1);
        final int asIndex = chunk.codeAt(ip + 2);
        final String name = program.constantAt(asIndex) as String;
        output.writeln('$variableName.addCode($moduleIndex);');
        output.writeln("$variableName.addConstant($asIndex, '$name');");
        bump += 2;
        break;

      default:
    }
    ip += bump;
  }
  return output.toString().trim();
}

void printExpectedProgramCode(final BeizeProgramConstant program) {
  // ignore: avoid_print
  print(buildExpectedProgramCode(program));
}

String escapedString(final String value, final String char) =>
    value.replaceAll(char, '\\$char');

typedef BeizeTestComparableProgram = Map<String, dynamic>;

// (transpile to) Test-Comparable-Program (from) (Beize)-Chunk
BeizeTestComparableProgram tcpc(final BeizeProgramConstant program) =>
    transpileTestComparableProgram(program.modules, program.constants);

// (transpile to) Test-Comparable-Program (from) (Beize)-Test-Chunk
BeizeTestComparableProgram tcptc(final BeizeTestProgram program) =>
    transpileTestComparableProgram(program.modules, program.constants);

BeizeTestComparableProgram transpileTestComparableProgram(
  final List<int> modules,
  final List<BeizeConstant> constants,
) {
  final List<dynamic> transpiledConstants = <dynamic>[];
  for (final BeizeConstant x in constants) {
    if (x is BeizeFunctionConstant) {
      transpiledConstants.add(<String, dynamic>{
        'moduleIndex': x.chunk.moduleIndex,
        'codes': x.chunk.codes,
      });
    } else {
      transpiledConstants.add(x);
    }
  }
  return <String, dynamic>{
    'modules': modules,
    'constants': transpiledConstants,
  };
}
