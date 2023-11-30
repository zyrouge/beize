import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] Match (3)';
  final BeizeProgramConstant program = await compileTestScript(
    'match_statement',
    'match_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-else'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}