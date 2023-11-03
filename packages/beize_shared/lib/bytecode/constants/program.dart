import 'constant.dart';
import 'function.dart';

class BeizeProgramConstant {
  const BeizeProgramConstant({
    required this.modules,
    required this.constants,
  });

  factory BeizeProgramConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeProgramConstant(
        modules: (serialized[0] as List<dynamic>).cast<int>(),
        constants: (serialized[1] as List<dynamic>).map((final dynamic x) {
          if (x is List<dynamic>) {
            return BeizeFunctionConstant.deserialize(x);
          }
          return x;
        }).toList(),
      );

  final List<int> modules;
  final List<BeizeConstant> constants;

  String moduleNameAt(final int index) => constantAt(modules[index]) as String;

  BeizeFunctionConstant moduleFunctionAt(final int index) =>
      constantAt(modules[index + 1]) as BeizeFunctionConstant;

  BeizeConstant constantAt(final int index) => constants[index];

  BeizeSerializedConstant serialize() => <dynamic>[
        modules,
        constants.map((final BeizeConstant x) {
          if (x is BeizeFunctionConstant) return x.serialize();
          return x;
        }).toList(),
      ];
}
