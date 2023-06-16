import 'constant.dart';
import 'function.dart';

class BeizeProgramConstant {
  BeizeProgramConstant({
    required this.modules,
    required this.entrypoint,
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

  final Map<String, BeizeFunctionConstant> modules;
  final String entrypoint;

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
