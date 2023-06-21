import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] This (1)';
  final BeizeProgramConstant program =
      await compileTestScript('this_operator', 'this_1.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestChunk expectedChunk = BeizeTestChunk();
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(1, 'value');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(2, 'c-0');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(3, 'getValue');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
final BeizeTestChunk expectedChunk_0 = BeizeTestChunk();
expectedChunk_0.addOpCode(BeizeOpCodes.opLookup);
expectedChunk_0.addConstant(0, 'this');
expectedChunk_0.addOpCode(BeizeOpCodes.opConstant);
expectedChunk_0.addConstant(1, 'value');
expectedChunk_0.addOpCode(BeizeOpCodes.opGetProperty);
expectedChunk_0.addOpCode(BeizeOpCodes.opReturn);
expectedChunk.addConstant(4, expectedChunk_0);
expectedChunk.addOpCode(BeizeOpCodes.opObject);
expectedChunk.addCode(2);
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(0, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(5, 'out');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(0, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(3, 'getValue');
expectedChunk.addOpCode(BeizeOpCodes.opGetProperty);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(0);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
