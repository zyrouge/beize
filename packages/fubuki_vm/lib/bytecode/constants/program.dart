import 'constant.dart';
import 'function.dart';

class FubukiProgramConstant {
  FubukiProgramConstant({
    required this.modules,
    required this.entrypoint,
  });

  factory FubukiProgramConstant.deserialize(
    final FubukiSerializedConstant serialized,
  ) =>
      FubukiProgramConstant(
        modules: (serialized[0] as Map<dynamic, dynamic>).map(
          (final dynamic key, final dynamic value) =>
              MapEntry<String, FubukiFunctionConstant>(
            key as String,
            FubukiFunctionConstant.deserialize(
              value as FubukiSerializedConstant,
            ),
          ),
        ),
        entrypoint: serialized[1] as String,
      );

  final Map<String, FubukiFunctionConstant> modules;
  final String entrypoint;

  FubukiSerializedConstant serialize() {
    final Map<String, FubukiSerializedConstant> serializedModules = modules.map(
      (final String key, final FubukiFunctionConstant value) =>
          MapEntry<String, FubukiSerializedConstant>(
        key,
        value.serialize(),
      ),
    );
    return <dynamic>[serializedModules, entrypoint];
  }
}
