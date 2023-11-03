import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Bitwise OR Assignment (2)';
  final BeizeProgramConstant program = await compileTestScript(
    'bitwise_or_assignment_operator',
    'bitwise_or_assignment_2.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['0'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
