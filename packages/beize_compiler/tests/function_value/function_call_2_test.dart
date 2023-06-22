import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] Function (2)';
  final BeizeProgramConstant program =
      await compileTestScript('function_value', 'function_call_2.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestChunk expectedChunk = BeizeTestChunk();
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
final BeizeTestChunk expectedChunk_0 = BeizeTestChunk();
expectedChunk_0.addOpCode(BeizeOpCodes.opBeginScope);
expectedChunk_0.addOpCode(BeizeOpCodes.opLookup);
expectedChunk_0.addConstant(0, 'out');
expectedChunk_0.addOpCode(BeizeOpCodes.opConstant);
expectedChunk_0.addConstant(1, 'c-0');
expectedChunk_0.addOpCode(BeizeOpCodes.opCall);
expectedChunk_0.addCode(1);
expectedChunk_0.addOpCode(BeizeOpCodes.opPop);
expectedChunk_0.addOpCode(BeizeOpCodes.opConstant);
expectedChunk_0.addConstant(2, 'c-1');
expectedChunk_0.addOpCode(BeizeOpCodes.opReturn);
expectedChunk_0.addOpCode(BeizeOpCodes.opEndScope);
expectedChunk.addConstant(1, expectedChunk_0);
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(0, 'value');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(0, 'value');
expectedChunk.addOpCode(BeizeOpCodes.opConstant);
expectedChunk.addConstant(3, 'call');
expectedChunk.addOpCode(BeizeOpCodes.opGetProperty);
expectedChunk.addOpCode(BeizeOpCodes.opList);
expectedChunk.addCode(0);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
expectedChunk.addConstant(2, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(4, 'out');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(5, 'typeof');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(2, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opPop);
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(4, 'out');
expectedChunk.addOpCode(BeizeOpCodes.opLookup);
expectedChunk.addConstant(2, 'result');
expectedChunk.addOpCode(BeizeOpCodes.opAwait);
expectedChunk.addOpCode(BeizeOpCodes.opCall);
expectedChunk.addCode(1);
expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['Unawaited', 'c-0', 'c-1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
