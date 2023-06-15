import 'package:baize_compiler/baize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = 'Import (1)';
  final BaizeProgramConstant program =
      await compileTestScript('import_statement', 'import_1.baize');

  test('$title - Bytecode', () async {
    final BaizeChunk chunk = extractChunk(program);
    final BaizeTestChunk expectedChunk = BaizeTestChunk();
    expectedChunk.addOpCode(BaizeOpCodes.opModule);
    expectedChunk.addConstant(0, 'import_dummy.baize');
    expectedChunk.addConstant(1, 'dummy');
    expectedChunk.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk.addConstant(1, 'dummy');
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(2, 'callOut');
    expectedChunk.addOpCode(BaizeOpCodes.opGetProperty);
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    expectedChunk.addConstant(3, 'c-0');
    expectedChunk.addOpCode(BaizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Bytecode (Dummy File)', () async {
    final BaizeChunk chunk = program.modules['import_dummy.baize']!.chunk;
    final BaizeTestChunk expectedChunk = BaizeTestChunk();
    expectedChunk.addOpCode(BaizeOpCodes.opConstant);
    final BaizeTestChunk expectedChunk_0 = BaizeTestChunk();
    expectedChunk_0.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk_0.addConstant(0, 'out');
    expectedChunk_0.addOpCode(BaizeOpCodes.opLookup);
    expectedChunk_0.addConstant(1, 'value');
    expectedChunk_0.addOpCode(BaizeOpCodes.opCall);
    expectedChunk_0.addCode(1);
    expectedChunk_0.addOpCode(BaizeOpCodes.opReturn);
    expectedChunk.addConstant(1, expectedChunk_0);
    expectedChunk.addOpCode(BaizeOpCodes.opDeclare);
    expectedChunk.addConstant(0, 'callOut');
    expectedChunk.addOpCode(BaizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
