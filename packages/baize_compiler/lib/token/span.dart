import '../lexer/exports.dart';

class BaizeSpan {
  const BaizeSpan(this.start, this.end);

  factory BaizeSpan.fromSingleCursor(final BaizeCursor cursor) =>
      BaizeSpan(cursor, cursor);

  final BaizeCursor start;
  final BaizeCursor end;

  @override
  String toString() => isSameCursor ? start.toString() : '$start - $end';

  bool get isSameCursor => start.position == end.position;
}
