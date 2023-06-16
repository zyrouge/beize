abstract class BeizeDisassemblerOutput {
  void write(final String text);

  BeizeDisassemblerConsoleOutput get nested;
}

class BeizeDisassemblerConsoleOutput extends BeizeDisassemblerOutput {
  BeizeDisassemblerConsoleOutput([this.spaces = 0]);

  int spaces;

  @override
  void write(final String text) {
    // ignore: avoid_print
    print('$prefix$text');
  }

  @override
  BeizeDisassemblerConsoleOutput get nested =>
      BeizeDisassemblerConsoleOutput(spaces + 1);

  String get prefix => '  ' * spaces;
}
