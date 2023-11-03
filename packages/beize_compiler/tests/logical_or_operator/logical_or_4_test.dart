import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Logical OR (4)';
  final BeizeProgramConstant program = await compileTestScript(
    'logical_or_operator',
    'logical_or_4.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['false'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
