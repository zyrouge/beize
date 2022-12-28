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
  FubukiSerializedConstant serialize() => <dynamic>[
        FubukiSerializableConstants.function.index,
        arguments,
        chunk.serialize()
      ];

  static const int kArguments = 1;
  static const int kChunk = 2;
}
