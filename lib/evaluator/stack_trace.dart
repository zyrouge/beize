import '../lexer/exports.dart';

class OutreStackFrame {
  const OutreStackFrame(this.name, this.file, this.span);

  final String name;
  final String file;
  final OutreSpan span;

  @override
  String toString() => '$name ($file at ${span.toPositionString()})';
}

class OutreStackTrace {
  final List<OutreStackFrame> frames = <OutreStackFrame>[];

  void push(final OutreStackFrame frame) {
    frames.insert(0, frame);
  }

  OutreStackFrame pop() => frames.removeAt(0);

  @override
  String toString() => frames
      .asMap()
      .entries
      .map((final MapEntry<int, OutreStackFrame> x) => '#${x.key} ${x.value}')
      .join('\n');

  int get length => frames.length;
}
