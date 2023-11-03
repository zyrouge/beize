import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] If-Else (2)';
  final BeizeProgramConstant program = await compileTestScript(
    'if-else_statement',
    'if-else_2.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
