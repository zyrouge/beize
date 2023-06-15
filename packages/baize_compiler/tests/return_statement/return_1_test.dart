import 'package:baize_compiler/baize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = 'Return (1)';
  final BaizeProgramConstant program =
      await compileTestScript('return_statement', 'return_1.baize');

  test('$title - Bytecode', () async {
    final BaizeChunk chunk = extractChunk(program);
    final BaizeTestChunk expectedChunk = BaizeTestChunk();
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    final BaizeTestChunk expectedChunk_0 = BaizeTestChunk();
    expectedChunk_0.addOpCode(BaizeOpCodes.opBeginScope);
    expectedChunk_0.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk_0.addConstant(0, 'c-0');
    expectedChunk_0.addOpCode(BaizeOpCodes.opReturn);
    expectedChunk_0.addOpCode(BaizeOpCodes.opEndScope);
    expectedChunk.addConstant(1, expectedChunk_0);
    expectedChunk.addOpCode(BaizeOpCodes.opDeclare);
    expectedChunk.addConstant(0, 'fn');
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(2, 'out');
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'fn');
    expectedChunk.addOpCode(BaizeOpCodes.opCall);
    expectedChunk.addCode(0);
    expectedChunk.addOpCode(BaizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
