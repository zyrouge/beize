import '../chunk.dart';

class BeizeFunctionConstant {
  BeizeFunctionConstant({
    required this.moduleIndex,
    required this.isAsync,
    required this.arguments,
    required this.chunk,
  });

  final int moduleIndex;
  final bool isAsync;
  final List<int> arguments;
  final BeizeChunk chunk;
}
