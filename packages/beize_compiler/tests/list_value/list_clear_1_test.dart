import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] List.Clear (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'list_value',
    'list_clear_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>[''];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
