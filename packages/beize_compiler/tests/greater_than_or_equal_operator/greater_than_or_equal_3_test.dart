import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Greater Than Or Equal (3)';
  final BeizeProgramConstant program = await compileTestScript(
    'greater_than_or_equal_operator',
    'greater_than_or_equal_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['false'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
