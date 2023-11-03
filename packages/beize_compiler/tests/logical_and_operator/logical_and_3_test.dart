import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Logical AND (3)';
  final BeizeProgramConstant program = await compileTestScript(
    'logical_and_operator',
    'logical_and_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['false'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
