import '../chunk.dart';
import 'constant.dart';

class BeizeClassConstant {
  BeizeClassConstant({
    required this.moduleIndex,
    required this.chunk,
  });

  factory BeizeClassConstant.deserialize(
    final BeizeSerializedConstant serialized,
  ) =>
      BeizeClassConstant(
        moduleIndex: serialized[0] as int,
        chunk: BeizeChunk.deserialize(serialized[1] as BeizeSerializedConstant),
      );

  final int moduleIndex;
  final BeizeChunk chunk;

  BeizeSerializedConstant serialize() =>
      <dynamic>[moduleIndex, chunk.serialize()];
}
