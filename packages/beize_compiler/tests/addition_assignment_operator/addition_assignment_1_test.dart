import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Addition Assignment (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'addition_assignment_operator',
    'addition_assignment_1.beize',
  );

  test('$title - Bytecode', () async {
    final BeizeTestProgram expectedProgram = BeizeTestProgram();
    final BeizeTestChunk expectedModule0 =
        expectedProgram.addModule(0, 0, 'addition_assignment_1.beize');
    expectedModule0.addOpCode(BeizeOpCodes.opConstant);
    expectedModule0.addConstant(3, 1.0);
    expectedModule0.addOpCode(BeizeOpCodes.opDeclare);
    expectedModule0.addConstant(2, 'result');
    expectedModule0.addOpCode(BeizeOpCodes.opPop);
    expectedModule0.addOpCode(BeizeOpCodes.opLookup);
    expectedModule0.addConstant(2, 'result');
    expectedModule0.addOpCode(BeizeOpCodes.opConstant);
    expectedModule0.addConstant(4, 2.0);
    expectedModule0.addOpCode(BeizeOpCodes.opAdd);
    expectedModule0.addOpCode(BeizeOpCodes.opAssign);
    expectedModule0.addConstant(2, 'result');
    expectedModule0.addOpCode(BeizeOpCodes.opPop);
    expectedModule0.addOpCode(BeizeOpCodes.opLookup);
    expectedModule0.addConstant(5, 'out');
    expectedModule0.addOpCode(BeizeOpCodes.opConstant);
    expectedModule0.addConstant(6, '');
    expectedModule0.addOpCode(BeizeOpCodes.opLookup);
    expectedModule0.addConstant(2, 'result');
    expectedModule0.addOpCode(BeizeOpCodes.opAdd);
    expectedModule0.addOpCode(BeizeOpCodes.opCall);
    expectedModule0.addCode(1);
    expectedModule0.addOpCode(BeizeOpCodes.opPop);
    expect(tcpc(program), tcptc(expectedProgram));
  });

  test('$title - Channel', () async {
    final List<String> expected = <String>['3'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
