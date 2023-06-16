import '../chunk.dart';
import 'constant.dart';

class BeizeFunctionConstant {
  BeizeFunctionConstant({
    required this.arguments,
    required this.chunk,
  });

  factory BeizeFunctionConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeFunctionConstant(
        arguments: (serialized[0] as List<dynamic>).cast<String>(),
        chunk: BeizeChunk.deserialize(
          serialized[1] as BeizeSerializedConstant,
        ),
      );

  final List<String> arguments;
  final BeizeChunk chunk;

  BeizeSerializedConstant serialize() =>
      <dynamic>[arguments, chunk.serialize()];
}
