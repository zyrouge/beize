import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Member Access (2)';
  final BeizeProgramConstant program = await compileTestScript(
    'member_access_operator',
    'member_access_2.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['Null'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
