import '../lexer/exports.dart';

class BeizeSpan {
  const BeizeSpan(this.start, this.end);

  factory BeizeSpan.fromSingleCursor(final BeizeCursor cursor) =>
      BeizeSpan(cursor, cursor);

  final BeizeCursor start;
  final BeizeCursor end;

  @override
  String toString() => isSameCursor ? start.toString() : '$start - $end';

  bool get isSameCursor => start.position == end.position;
}
