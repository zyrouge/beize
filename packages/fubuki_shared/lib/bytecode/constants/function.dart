import '../chunk.dart';
import 'constant.dart';

class FubukiFunctionConstant {
  FubukiFunctionConstant({
    required this.arguments,
    required this.chunk,
  });

  factory FubukiFunctionConstant.deserialize(
    final FubukiSerializedConstant serialized,
  ) =>
      FubukiFunctionConstant(
        arguments: (serialized[0] as List<dynamic>).cast<String>(),
        chunk: FubukiChunk.deserialize(
          serialized[1] as FubukiSerializedConstant,
        ),
      );

  final List<String> arguments;
  final FubukiChunk chunk;

  FubukiSerializedConstant serialize() =>
      <dynamic>[arguments, chunk.serialize()];
}
