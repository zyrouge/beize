abstract class FubukiDisassemblerOutput {
  void write(final String text);

  FubukiDisassemblerConsoleOutput get nested;
}

class FubukiDisassemblerConsoleOutput extends FubukiDisassemblerOutput {
  FubukiDisassemblerConsoleOutput([this.spaces = 0]);

  int spaces;

  @override
  void write(final String text) {
    // ignore: avoid_print
    print('$prefix$text');
  }

  @override
  FubukiDisassemblerConsoleOutput get nested =>
      FubukiDisassemblerConsoleOutput(spaces + 1);

  String get prefix => '  ' * spaces;
}
