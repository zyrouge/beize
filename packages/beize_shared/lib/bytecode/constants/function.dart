import '../chunk.dart';
import 'constant.dart';

class BeizeFunctionConstant {
  BeizeFunctionConstant({
    required this.moduleIndex,
    required this.isAsync,
    required this.arguments,
    required this.chunk,
  });

  factory BeizeFunctionConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeFunctionConstant(
        moduleIndex: serialized[0] as int,
        isAsync: serialized[1] == 1,
        arguments: (serialized[2] as List<dynamic>).cast<int>(),
        chunk: BeizeChunk.deserialize(
          serialized[3] as BeizeSerializedConstant,
        ),
      );

  final int moduleIndex;
  final bool isAsync;
  final List<int> arguments;
  final BeizeChunk chunk;

  BeizeSerializedConstant serialize() => <dynamic>[
        moduleIndex,
        if (isAsync) 1 else 0,
        arguments,
        chunk.serialize(),
      ];
}
