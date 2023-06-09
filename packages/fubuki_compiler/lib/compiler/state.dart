class FubukiCompilerLoopState {
  FubukiCompilerLoopState({
    required this.scopeDepth,
    required this.start,
    required this.endJump,
  });

  int scopeDepth;
  int start;
  final int endJump;
  final List<int> exitJumps = <int>[];
}
