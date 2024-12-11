import 'constant.dart';
import 'function.dart';

class BeizeProgramConstant {
  BeizeProgramConstant({
    required this.version,
    required this.modules,
    required this.constants,
  });

  final int version;
  final List<int> modules;
  final List<BeizeConstant> constants;

  String moduleNameAt(final int index) => constantAt(modules[index]) as String;

  BeizeFunctionConstant moduleFunctionAt(final int index) =>
      constantAt(modules[index + 1]) as BeizeFunctionConstant;

  BeizeConstant constantAt(final int index) => constants[index];
}
