import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[Operator] Nullable Assignment (1)';
  final BeizeProgramConstant program = await compileTestScript(
    'nullable_assignment_operator',
    'nullable_assignment_1.beize',
  );

  test('$title - Channel', () async {
    final List<String> expected = <String>['null', 'c-0'];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
