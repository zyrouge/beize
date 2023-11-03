import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] String.ToCodeUnits (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'string_value',
    'string_toCodeUnits_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['72, 101, 108, 108, 111, 33'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
