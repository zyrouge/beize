import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Statement] For (3)';
  final BeizeProgramConstant program = await compileTestScript(
    'for_statement',
    'for_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['c-0', 'c-2', 'c-4'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
