import '../chunk.dart';
import 'constant.dart';

class FubukiFunctionConstant with FubukiSerializableConstant {
  FubukiFunctionConstant({
    required this.arguments,
    required this.chunk,
  });

  factory FubukiFunctionConstant.deserialize(
    final FubukiSerializedConstant serialized,
  ) =>
      FubukiFunctionConstant(
        arguments: (serialized[kArguments] as List<dynamic>).cast<String>(),
        chunk: FubukiChunk.deserialize(
          serialized[kChunk] as FubukiSerializedConstant,
        ),
      );

  final List<String> arguments;
  final FubukiChunk chunk;

  @override
  FubukiSerializedConstant serialize() => <dynamic, dynamic>{
        FubukiSerializableConstant.kKind: kKindV,
        kArguments: arguments,
        kChunk: chunk.serialize(),
      };

  static const String kKindV = 'kind';
  static const String kArguments = 'arguments';
  static const String kChunk = 'chunk';
}
