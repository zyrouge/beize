import 'constant.dart';
import 'function.dart';

class BeizeProgramConstant {
  BeizeProgramConstant({
    required this.moduleNames,
    required this.modules,
  });

  factory BeizeProgramConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeProgramConstant(
        moduleNames: (serialized[0] as List<dynamic>).cast<String>(),
        modules: (serialized[1] as List<dynamic>)
            .map(
              (final dynamic x) => BeizeFunctionConstant.deserialize(
                x as BeizeSerializedConstant,
              ),
            )
            .toList(),
      );

  final List<String> moduleNames;
  final List<BeizeFunctionConstant> modules;

  String moduleNameAt(final int index) => moduleNames[index];
  BeizeFunctionConstant moduleAt(final int index) => modules[index];

  BeizeSerializedConstant serialize() => <dynamic>[
        moduleNames,
        modules.map((final BeizeFunctionConstant x) => x.serialize()).toList(),
      ];
}
