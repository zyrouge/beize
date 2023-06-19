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
        isAsync: serialized[0] as bool,
        arguments: (serialized[1] as List<dynamic>).cast<String>(),
        chunk: BeizeChunk.deserialize(
          serialized[2] as BeizeSerializedConstant,
        ),
      );

  final bool isAsync;
  final List<String> arguments;
  final BeizeChunk chunk;

  BeizeSerializedConstant serialize() =>
      <dynamic>[isAsync, arguments, chunk.serialize()];
}
