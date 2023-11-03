import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] If-Else (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'if_statement',
    'if_else_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
