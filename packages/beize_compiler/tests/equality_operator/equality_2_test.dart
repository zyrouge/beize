import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Equality (2)';
  final BeizeProgramConstant program =
      await compileTestScript('equality_operator', 'equality_2.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestChunk expectedChunk = BeizeTestChunk();
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(1, 'c-0');
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(0, 'value1');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(3, 'c-1');
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(2, 'value2');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(0, 'value1');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(2, 'value2');
expectedChunk.addOpCode(BeizeOpCodes.opEqual);
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(4, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(5, 'out');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(6, '');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(4, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opAdd);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['false'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
