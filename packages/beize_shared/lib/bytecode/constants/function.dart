import '../chunk.dart';
import 'constant.dart';

class BeizeFunctionConstant {
  BeizeFunctionConstant({
    required this.isAsync,
    required this.arguments,
    required this.chunk,
  });

  factory BeizeFunctionConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeFunctionConstant(
        isAsync: serialized[0] == 1,
        arguments: (serialized[1] as List<dynamic>).cast<int>(),
        chunk: BeizeChunk.deserialize(
          serialized[2] as BeizeSerializedConstant,
        ),
      );

  final bool isAsync;
  final List<int> arguments;
  final BeizeChunk chunk;

  BeizeSerializedConstant serialize() =>
      <dynamic>[if (isAsync) 1 else 0, arguments, chunk.serialize()];
}
