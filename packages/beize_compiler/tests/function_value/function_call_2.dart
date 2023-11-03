import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Value] Function Call (2)';
  final BeizeProgramConstant program = await compileTestScript(
    'function_value',
    'function_3.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['Unawaited', 'c-0', 'c-1'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
