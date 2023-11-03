import 'constant.dart';
import 'function.dart';

class BeizeProgramConstant {
  const BeizeProgramConstant({
    // required this.moduleNames,
    required this.modules,
    required this.constants,
  });

  factory BeizeProgramConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeProgramConstant(
        modules: (serialized[0] as List<dynamic>).cast<int>(),
        // modules: (serialized[1] as List<dynamic>)
        //     .map(
        //       (final dynamic x) => BeizeFunctionConstant.deserialize(
        //         x as BeizeSerializedConstant,
        //       ),
        //     )
        //     .toList(),
        constants: (serialized[1] as List<dynamic>).map((final dynamic x) {
          if (x is List<dynamic>) {
            return BeizeFunctionConstant.deserialize(x);
          }
          return x;
        }).toList(),
      );

  // final List<String> moduleNames;
  final List<int> modules;
  final List<BeizeConstant> constants;

  int moduleAt(final int index) => modules[index];
  BeizeConstant constantAt(final int index) => constants[index];

  BeizeSerializedConstant serialize() => <dynamic>[
        modules,
        constants.map((final BeizeConstant x) {
          if (x is BeizeFunctionConstant) return x.serialize();
          return x;
        }).toList(),
      ];
}
