import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] For (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'for_statement',
    'for_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0', 'c-1', 'c-2'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
