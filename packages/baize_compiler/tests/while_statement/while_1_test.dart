import 'package:baize_compiler/baize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = 'While (1)';
  final BaizeProgramConstant program =
      await compileTestScript('while_statement', 'while_1.baize');

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
    expectedChunk.addOpCode(BaizeOpCodes.opJumpIfFalse);
    expectedChunk.addCode(23);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opBeginScope);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(3, 'out');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(4, 'c-');
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opAdd);
    expectedChunk.addOpCode(BaizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(5, 1.0);
    expectedChunk.addOpCode(BaizeOpCodes.opAdd);
    expectedChunk.addOpCode(BaizeOpCodes.opAssign);
    expectedChunk.addConstant(0, 'i');
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opEndScope);
    expectedChunk.addOpCode(BaizeOpCodes.opAbsoluteJump);
    expectedChunk.addCode(5);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0', 'c-1', 'c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
