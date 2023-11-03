import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] For (1)';
  final BeizeProgramConstant program =
      await compileTestScript('for_statement', 'for_1.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestProgram expectedChunk = BeizeTestProgram();
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(1, 0.0);
    expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(2, 3.0);
    expectedChunk.addOpCode(BeizeOpCodes.opLess);
    expectedChunk.addOpCode(BeizeOpCodes.opJump);
    expectedChunk.addCode(10);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(3, 1.0);
    expectedChunk.addOpCode(BeizeOpCodes.opAdd);
    expectedChunk.addOpCode(BeizeOpCodes.opAssign);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(5);
    expectedChunk.addOpCode(BeizeOpCodes.opJumpIfFalse);
    expectedChunk.addCode(15);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opBeginScope);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(4, 'out');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(5, 'c-');
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BeizeOpCodes.opAdd);
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opEndScope);
    expectedChunk.addOpCode(BeizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(12);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0', 'c-1', 'c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
