import 'package:baize_compiler/baize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = 'Continue (1)';
  final BaizeProgramConstant program =
      await compileTestScript('continue_statement', 'continue_1.baize');

  test('$title - Bytecode', () async {
    final BaizeChunk chunk = extractChunk(program);
    final BaizeTestChunk expectedChunk = BaizeTestChunk();
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(1, 0.0);
    expectedChunk.addOpCode(BaizeOpCodes.opDeclare);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(2, 3.0);
    expectedChunk.addOpCode(BaizeOpCodes.opLess);
    expectedChunk.addOpCode(BaizeOpCodes.opJump);
    expectedChunk.addCode(10);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(3, 1.0);
    expectedChunk.addOpCode(BaizeOpCodes.opAdd);
    expectedChunk.addOpCode(BaizeOpCodes.opAssign);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(5);
    expectedChunk.addOpCode(BaizeOpCodes.opJumpIfFalse);
    expectedChunk.addCode(28);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opBeginScope);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(3, 1.0);
    expectedChunk.addOpCode(BaizeOpCodes.opEqual);
    expectedChunk.addOpCode(BaizeOpCodes.opJumpIfFalse);
    expectedChunk.addCode(5);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(12);
    expectedChunk.addOpCode(BaizeOpCodes.opJump);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(4, 'out');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(5, 'c-');
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opAdd);
    expectedChunk.addOpCode(BaizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opEndScope);
    expectedChunk.addOpCode(BaizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(12);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0', 'c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
