import '../chunk.dart';
import 'constant.dart';

class BaizeFunctionConstant {
  BaizeFunctionConstant({
    required this.arguments,
    required this.chunk,
  });

  factory BaizeFunctionConstant.deserialize(
    final BaizeSerializedConstant serialized,
  ) =>
      BaizeFunctionConstant(
        arguments: (serialized[0] as List<dynamic>).cast<String>(),
        chunk: BaizeChunk.deserialize(
          serialized[1] as BaizeSerializedConstant,
        ),
      );

  final List<String> arguments;
  final BaizeChunk chunk;

  BaizeSerializedConstant serialize() =>
      <dynamic>[arguments, chunk.serialize()];
}
