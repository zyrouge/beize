import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Unary Negation (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'unary_negation_operator',
    'unary_negation_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['-1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
