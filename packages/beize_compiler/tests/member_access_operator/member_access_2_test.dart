import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Member Access (2)';
  final BeizeProgramConstant program =
      await compileTestScript('member_access_operator', 'member_access_2.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestChunk expectedChunk = BeizeTestChunk();
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(1, 'value');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(2, 'c-0');
expectedChunk.addOpCode(BeizeOpCodes.opObject);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(0, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(3, 'out');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(4, 'typeof');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(0, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(5, 'value1');
expectedChunk.addOpCode(BeizeOpCodes.opGetProperty);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['Null'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}