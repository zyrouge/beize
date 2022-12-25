class FubukiCompilerLoopState {
  FubukiCompilerLoopState({
    required this.scopeDepth,
    required this.start,
  });

  int scopeDepth;
  int start;
  final List<int> exitJumps = <int>[];
}
