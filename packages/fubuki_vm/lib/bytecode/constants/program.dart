import '../chunk.dart';

class FubukiProgramConstant {
  FubukiProgramConstant({
    required this.main,
    required this.modules,
  });

  final Map<String, FubukiChunk> modules;
  final FubukiChunk main;
}
