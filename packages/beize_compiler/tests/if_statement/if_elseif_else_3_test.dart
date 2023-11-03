import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] If-ElseIf-Else (2)';
  final BeizeProgramConstant program = await compileTestScript(
    'if_statement',
    'if_elseif_else_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-3'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
