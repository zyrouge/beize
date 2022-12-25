import '../lexer/exports.dart';

class FubukiSpan {
  const FubukiSpan(this.start, this.end);

  factory FubukiSpan.fromSingleCursor(final FubukiCursor cursor) =>
      FubukiSpan(cursor, cursor);

  final FubukiCursor start;
  final FubukiCursor end;

  @override
  String toString() => isSameCursor ? start.toString() : '$start - $end';

  bool get isSameCursor => start.position == end.position;
}
