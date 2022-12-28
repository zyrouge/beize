import 'constant.dart';
import 'function.dart';

class FubukiProgramConstant with FubukiSerializableConstant {
  FubukiProgramConstant({
    required this.modules,
    required this.entrypoint,
  });

  factory FubukiProgramConstant.deserialize(
    final FubukiSerializedConstant serialized,
  ) =>
      FubukiProgramConstant(
        modules: (serialized[kModules] as Map<dynamic, dynamic>).map(
          (final dynamic key, final dynamic value) =>
              MapEntry<String, FubukiFunctionConstant>(
            key as String,
            FubukiFunctionConstant.deserialize(
              value as FubukiSerializedConstant,
            ),
          ),
        ),
        entrypoint: serialized[kEntrypoint] as String,
      );

  final Map<String, FubukiFunctionConstant> modules;
  final String entrypoint;

  @override
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

  static const int kModules = 0;
  static const int kEntrypoint = 1;
}
