import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] List (1)';
  final BeizeProgramConstant program =
      await compileTestScript('list_value', 'list_sort_1.beize');

  test('$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    final BeizeTestProgram expectedChunk = BeizeTestProgram();
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(1, 'c-1');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(2, 'c-2');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(3, 'c-0');
    expectedChunk.addOpCode(BeizeOpCodes.opList);
    expectedChunk.addCode(3);
    expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
    expectedChunk.addConstant(0, 'result');
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(0, 'result');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(5, 'sort');
    expectedChunk.addOpCode(BeizeOpCodes.opGetProperty);
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    final BeizeTestProgram expectedChunk_0 = BeizeTestProgram();
    expectedChunk_0.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk_0.addConstant(0, 'a');
    expectedChunk_0.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk_0.addConstant(1, 'compareTo');
    expectedChunk_0.addOpCode(BeizeOpCodes.opGetProperty);
    expectedChunk_0.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk_0.addConstant(2, 'b');
    expectedChunk_0.addOpCode(BeizeOpCodes.opCall);
    expectedChunk_0.addCode(1);
    expectedChunk_0.addOpCode(BeizeOpCodes.opReturn);
    expectedChunk.addConstant(6, expectedChunk_0);
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opDeclare);
    expectedChunk.addConstant(4, 'sorted');
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(7, 'out');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(8, '');
    expectedChunk.addOpCode(BeizeOpCodes.opLookup);
    expectedChunk.addConstant(4, 'sorted');
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(9, 'join');
    expectedChunk.addOpCode(BeizeOpCodes.opGetProperty);
    expectedChunk.addOpCode(BeizeOpCodes.opConstant);
    expectedChunk.addConstant(10, ', ');
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opAdd);
    expectedChunk.addOpCode(BeizeOpCodes.opCall);
    expectedChunk.addCode(1);
    expectedChunk.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0, c-1, c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
