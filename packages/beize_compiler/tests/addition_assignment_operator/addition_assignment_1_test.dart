import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Addition Assignment (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'addition_assignment_operator',
    'addition_assignment_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['3'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
