import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Bitwise AND (1)';
  final BeizeProgramConstant program =
      await compileTestScript('bitwise_and_operator', 'bitwise_and_1.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestProgram expectedChunk = BeizeTestProgram();
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(1, 1.0);
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(1, 1.0);
    expectedChunk.addOpCode(BeizeOpCodes.opBitwiseAnd);
    expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
    expectedChunk.addConstant(0, 'result');
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(2, 'out');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(3, '');
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'result');
    expectedChunk.addOpCode(BeizeOpCodes.opAdd);
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
