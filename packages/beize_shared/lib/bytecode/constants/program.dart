import 'constant.dart';
import 'function.dart';

class BeizeProgramConstant {
  BeizeProgramConstant({
    required this.names,
    required this.modules,
  });

  factory BeizeProgramConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeProgramConstant(
        modules: (serialized[0] as Map<dynamic, dynamic>).map(
          (final dynamic key, final dynamic value) =>
              MapEntry<String, BeizeFunctionConstant>(
            key as String,
            BeizeFunctionConstant.deserialize(
              value as BeizeSerializedConstant,
            ),
          ),
        ),
        entrypoint: serialized[1] as String,
      );

  final List<String> names;
  final List<BeizeFunctionConstant> modules;

  BeizeSerializedConstant serialize() {
    final Map<String, BeizeSerializedConstant> serializedModules = modules.map(
      (final String key, final BeizeFunctionConstant value) =>
          MapEntry<String, BeizeSerializedConstant>(
        key,
        value.serialize(),
      ),
    );
    return <dynamic>[serializedModules, entrypoint];
  }
}
