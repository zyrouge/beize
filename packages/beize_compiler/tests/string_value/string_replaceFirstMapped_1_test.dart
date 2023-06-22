import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] String (1)';
  final BeizeProgramConstant program =
      await compileTestScript('string_value', 'string_replaceFirstMapped_1.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestChunk expectedChunk = BeizeTestChunk();
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(1, 'Hello');
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(0, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(2, 'out');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(3, '');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(0, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(4, 'replaceFirstMapped');
expectedChunk.addOpCode(BeizeOpCodes.opGetProperty);
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(5, 'l');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
final BeizeTestChunk expectedChunk_0 = BeizeTestChunk();
expectedChunk_0.addOpCode(BeizeOpCodes.opLookup);
expectedChunk_0.addConstant(0, 'x');
expectedChunk_0.addOpCode(BeizeOpCodes.opConstant);
expectedChunk_0.addConstant(1, 'toUpperCase');
expectedChunk_0.addOpCode(BeizeOpCodes.opGetProperty);
expectedChunk_0.addOpCode(BeizeOpCodes.opCall);
expectedChunk_0.addCode(0);
expectedChunk_0.addOpCode(BeizeOpCodes.opReturn);
expectedChunk.addConstant(6, expectedChunk_0);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(2);
expectedChunk.addOpCode(BeizeOpCodes.opAdd);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['HeLlo'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
