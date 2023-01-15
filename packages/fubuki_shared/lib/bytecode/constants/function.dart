import '../chunk.dart';
import 'constant.dart';

class FubukiFunctionConstant {
  FubukiFunctionConstant({
    required this.arguments,
    required this.isAsync,
    required this.chunk,
  });

  factory FubukiFunctionConstant.deserialize(
    final FubukiSerializedConstant serialized,
  ) =>
      FubukiFunctionConstant(
        arguments: (serialized[0] as List<dynamic>).cast<String>(),
        isAsync: serialized[1] as bool,
        chunk: FubukiChunk.deserialize(
          serialized[2] as FubukiSerializedConstant,
        ),
      );

  bool isAsync;
  final List<String> arguments;
  final FubukiChunk chunk;

  FubukiSerializedConstant serialize() =>
      <dynamic>[arguments, isAsync, chunk.serialize()];
}
