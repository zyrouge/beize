import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Addition Assignment (1)';
  final BeizeProgramConstant program = await compileTestScript(
      'addition_assignment_operator', 'addition_assignment_1.beize');

  test('$title - Bytecode', () async {
    final BeizeTestProgram expectedProgram = BeizeTestProgram();
    final BeizeTestChunk expectedModule1 =
        expectedProgram.addModule(0, 0, 'addition_assignment_1.beize');
    expectedModule1.addOpCode(BeizeOpCodes.opConstant);
    expectedModule1.addConstant(1, 1.0);
    expectedModule1.addOpCode(BeizeOpCodes.opDeclare);
    expectedModule1.addConstant(0, 'result');
    expectedModule1.addOpCode(BeizeOpCodes.opPop);
    expectedModule1.addOpCode(BeizeOpCodes.opLookup);
    expectedModule1.addConstant(0, 'result');
    expectedModule1.addOpCode(BeizeOpCodes.opConstant);
    expectedModule1.addConstant(2, 2.0);
    expectedModule1.addOpCode(BeizeOpCodes.opAdd);
    expectedModule1.addOpCode(BeizeOpCodes.opAssign);
    expectedModule1.addConstant(0, 'result');
    expectedModule1.addOpCode(BeizeOpCodes.opPop);
    expectedModule1.addOpCode(BeizeOpCodes.opLookup);
    expectedModule1.addConstant(3, 'out');
    expectedModule1.addOpCode(BeizeOpCodes.opConstant);
    expectedModule1.addConstant(4, '');
    expectedModule1.addOpCode(BeizeOpCodes.opLookup);
    expectedModule1.addConstant(0, 'result');
    expectedModule1.addOpCode(BeizeOpCodes.opAdd);
    expectedModule1.addOpCode(BeizeOpCodes.opCall);
    expectedModule1.addCode(1);
    expectedModule1.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(program), tcptc(expectedProgram));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['3'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
