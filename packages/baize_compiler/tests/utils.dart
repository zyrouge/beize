import 'dart:io';
import 'package:baize_compiler/baize_compiler.dart';
import 'package:baize_vm/baize_vm.dart';
import 'package:path/path.dart' as p;

final String testsDir = p.join(Directory.current.path, 'tests');

Future<BaizeProgramConstant> compileTestScript(
  final String dir,
  final String scriptName,
) async {
  final BaizeProgramConstant program = await BaizeCompiler.compileProject(
    root: p.join(testsDir, dir),
    entrypoint: scriptName,
  );
  return program;
}

Future<List<String>> executeTestScript(
  final BaizeProgramConstant program,
) async {
  final BaizeVM vm = BaizeVM(program, BaizeVMOptions());
  final List<String> output = <String>[];
  final BaizeNativeFunctionValue out = BaizeNativeFunctionValue.sync(
    (final BaizeNativeFunctionCall call) {
      final BaizeStringValue value = call.argumentAt(0).cast();
      output.add(value.value);
      return BaizeNullValue.value;
    },
  );
  vm.globalNamespace.declare('out', out);
  await vm.run();
  return output;
}

BaizeChunk extractChunk(
  final BaizeProgramConstant program,
) {
  final BaizeChunk chunk = program.modules[program.entrypoint]!.chunk;
  return chunk;
}

class BaizeTestChunk {
  final BaizeChunk chunk = BaizeChunk.empty('testChunk');

  void addOpCode(final BaizeOpCodes opCode) {
    chunk.addOpCode(opCode, 0);
  }

  void addCode(final int code) {
    chunk.addCode(code, 0);
  }

  void addConstant(final int code, final BaizeConstant constant) {
    int missingCount = code - chunk.constants.length + 1;
    while (missingCount > 0) {
      chunk.constants.add(null);
      missingCount--;
    }
    chunk.constants[code] = constant;
    addCode(code);
  }

  List<int> get codes => chunk.codes;
  List<BaizeConstant> get constants => chunk.constants;
}

String buildExpectedChunkCode(
  final BaizeChunk chunk, {
  final String variableName = 'expectedChunk',
  final StringBuffer? buffer,
}) {
  final StringBuffer output = buffer ?? StringBuffer();
  output.writeln('final BaizeTestChunk $variableName = BaizeTestChunk();');
  int constantVariableCount = 0;
  int ip = 0;
  while (ip < chunk.codes.length) {
    final BaizeOpCodes opCode = chunk.opCodeAt(ip);
    int bump = 1;
    output.writeln('$variableName.addOpCode(BaizeOpCodes.${opCode.name});');
    switch (opCode) {
      case BaizeOpCodes.opConstant:
      case BaizeOpCodes.opDeclare:
      case BaizeOpCodes.opAssign:
      case BaizeOpCodes.opLookup:
        final int constantPosition = chunk.codeAt(ip + 1);
        final BaizeConstant constant = chunk.constantAt(constantPosition);
        if (constant is BaizeFunctionConstant) {
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

      case BaizeOpCodes.opJump:
      case BaizeOpCodes.opJumpIfFalse:
      case BaizeOpCodes.opJumpIfNull:
      case BaizeOpCodes.opAbsoluteJump:
      case BaizeOpCodes.opBeginTry:
      case BaizeOpCodes.opCall:
      case BaizeOpCodes.opList:
      case BaizeOpCodes.opObject:
        final int value = chunk.codeAt(ip + 1);
        output.writeln('$variableName.addCode($value);');
        bump++;
        break;

      case BaizeOpCodes.opModule:
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

void printExpectedChunkCode(final BaizeChunk chunk) {
  // ignore: avoid_print
  print(buildExpectedChunkCode(chunk));
}

String escapedString(final String value, final String char) =>
    value.replaceAll(char, '\\$char');

typedef BaizeTestComparableProgram = Map<String, dynamic>;

// (transpile to) Test-Comparable-Program (from) (Baize)-Chunk
BaizeTestComparableProgram tcpc(final BaizeChunk chunk) =>
    transpileTestComparableProgram(chunk.codes, chunk.constants);

// (transpile to) Test-Comparable-Program (from) (Baize)-Test-Chunk
BaizeTestComparableProgram tcptc(final BaizeTestChunk chunk) =>
    transpileTestComparableProgram(chunk.codes, chunk.constants);

BaizeTestComparableProgram transpileTestComparableProgram(
  final List<int> codes,
  final List<BaizeConstant> constants,
) {
  final List<dynamic> transpiledConstants = <dynamic>[];
  for (final BaizeConstant x in constants) {
    if (x is BaizeFunctionConstant) {
      transpiledConstants.add(
        transpileTestComparableProgram(x.chunk.codes, x.chunk.constants),
      );
    } else if (x is BaizeTestChunk) {
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
