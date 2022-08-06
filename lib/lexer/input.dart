import 'span.dart';
import 'utils.dart';

class OutreInputIteration {
  const OutreInputIteration(this.char, this.point);

  final String char;
  final OutreSpanPoint point;

  @override
  String toString() =>
      'OutreInputIteration("$char", ${point.toPositionString()})';
}

class OutreInput {
  OutreInput(this.source);

  final String source;
  late final int length = source.length;
  OutreSpanPoint point = const OutreSpanPoint();

  OutreInputIteration advance() {
    final OutreInputIteration previous = peek();
    final int position = point.position + 1;
    int row = point.row;
    int column = point.column + 1;

    if (isEndOfLine()) {
      row++;
      column = 0;
    }
    point = point.copyWith(position: position, row: row, column: column);
    return previous;
  }

  OutreInputIteration peek() =>
      OutreInputIteration(charAt(point.position), point);

  bool isEndOfLine() => peek().char == '\n';
  bool isEndOfFile() => !hasCharAt(point.position);

  bool hasCharAt(final int position) => position < length;
  String charAt(final int position) =>
      hasCharAt(position) ? source[position] : '';

  String getCharactersAt(final int position, final int offset) =>
      List<String>.generate(offset, (final int i) => charAt(position + i))
          .join();

  void skipWhitespace() {
    while (!isEndOfFile() && OutreLexerUtils.isWhitespace(peek().char)) {
      advance();
    }
  }
}
