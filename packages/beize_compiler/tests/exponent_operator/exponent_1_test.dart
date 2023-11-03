import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Exponent (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'exponent_operator',
    'exponent_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['25'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
