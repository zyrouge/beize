abstract class BaizeDisassemblerOutput {
  void write(final String text);

  BaizeDisassemblerConsoleOutput get nested;
}

class BaizeDisassemblerConsoleOutput extends BaizeDisassemblerOutput {
  BaizeDisassemblerConsoleOutput([this.spaces = 0]);

  int spaces;

  @override
  void write(final String text) {
    // ignore: avoid_print
    print('$prefix$text');
  }

  @override
  BaizeDisassemblerConsoleOutput get nested =>
      BaizeDisassemblerConsoleOutput(spaces + 1);

  String get prefix => '  ' * spaces;
}
