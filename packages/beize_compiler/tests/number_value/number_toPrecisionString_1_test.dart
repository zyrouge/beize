import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] Number.ToPrecisionString (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'number_value',
    'number_toPrecisionString_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['5.25'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
