import '../cursor.dart';
import '../utils.dart';
import 'iteration.dart';

class FubukiInput {
  FubukiInput(this.source);

  final String source;

  FubukiCursor cursor = const FubukiCursor();

  FubukiInputIteration advance() {
    final FubukiInputIteration previous = peek();
    final int position = cursor.position + 1;
    int row = cursor.row;
    int column = cursor.column + 1;

    if (isEndOfLine()) {
      row++;
      column = 0;
    }
    cursor = FubukiCursor(position: position, row: row, column: column);
    return previous;
  }

  FubukiInputIteration peek() =>
      FubukiInputIteration(charAt(cursor.position), cursor);

  bool isEndOfLine() => isEndOfFile() || peek().char == '\n';
  bool isEndOfFile() => !hasCharAt(cursor.position);

  bool hasCharAt(final int position) => position < length;
  String charAt(final int position) =>
      hasCharAt(position) ? source[position] : '';

  String getCharactersAt(final int position, final int offset) =>
      List<String>.generate(offset, (final int i) => charAt(position + i))
          .join();

  void skipWhitespace() {
    while (!isEndOfFile() && FubukiLexerUtils.isWhitespace(peek().char)) {
      advance();
    }
  }

  int get length => source.length;
}
