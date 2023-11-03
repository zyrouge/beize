import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Unary Plus (2)';
  final BeizeProgramConstant program = await compileTestScript(
    'unary_plus_operator',
    'unary_plus_2.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['-1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
