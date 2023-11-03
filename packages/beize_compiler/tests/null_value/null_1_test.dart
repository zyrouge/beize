import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] Null (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'null_value',
    'null_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['Null'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
