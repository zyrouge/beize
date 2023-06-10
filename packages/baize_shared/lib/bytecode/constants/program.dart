import 'constant.dart';
import 'function.dart';

class BaizeProgramConstant {
  BaizeProgramConstant({
    required this.modules,
    required this.entrypoint,
  });

  factory BaizeProgramConstant.deserialize(
    final BaizeSerializedConstant serialized,
  ) =>
      BaizeProgramConstant(
        modules: (serialized[0] as Map<dynamic, dynamic>).map(
          (final dynamic key, final dynamic value) =>
              MapEntry<String, BaizeFunctionConstant>(
            key as String,
            BaizeFunctionConstant.deserialize(
              value as BaizeSerializedConstant,
            ),
          ),
        ),
        entrypoint: serialized[1] as String,
      );

  final Map<String, BaizeFunctionConstant> modules;
  final String entrypoint;

  BaizeSerializedConstant serialize() {
    final Map<String, BaizeSerializedConstant> serializedModules = modules.map(
      (final String key, final BaizeFunctionConstant value) =>
          MapEntry<String, BaizeSerializedConstant>(
        key,
        value.serialize(),
      ),
    );
    return <dynamic>[serializedModules, entrypoint];
  }
}
