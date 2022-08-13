import '../lexer/exports.dart';
import 'exports.dart';

class OutreStackFrame with OutreConvertableValue {
  const OutreStackFrame(this.name, this.file, this.span);

  final String name;
  final String file;
  final OutreSpan span;

  @override
  OutreValue toOutreValue() => OutreStringValue(toString());

  @override
  String toString() => '$name ($file at ${span.toPositionString()})';
}

class OutreStackTrace with OutreConvertableValue {
  final List<OutreStackFrame> frames = <OutreStackFrame>[];

  void push(final OutreStackFrame frame) {
    frames.insert(0, frame);
  }

  OutreStackFrame pop() => frames.removeAt(0);

  @override
  OutreValue toOutreValue() => OutreArrayValue(
        frames.map((final OutreStackFrame x) => x.toOutreValue()).toList(),
      );

  @override
  String toString() => frames
      .asMap()
      .entries
      .map((final MapEntry<int, OutreStackFrame> x) => '#${x.key} ${x.value}')
      .join('\n');

  int get length => frames.length;
}
