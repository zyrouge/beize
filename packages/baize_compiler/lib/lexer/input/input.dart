import 'dart:io';
import '../cursor.dart';
import '../utils.dart';
import 'iteration.dart';

class BaizeInput {
  BaizeInput(this.source);

  final String source;

  BaizeCursor cursor = const BaizeCursor();

  BaizeInputIteration advance() {
    final BaizeInputIteration previous = peek();
    final int position = cursor.position + 1;
    int row = cursor.row;
    int column = cursor.column + 1;

    if (isEndOfLine()) {
      row++;
      column = 0;
    }
    cursor = BaizeCursor(position: position, row: row, column: column);
    return previous;
  }

  BaizeInputIteration peek() =>
      BaizeInputIteration(charAt(cursor.position), cursor);

  bool isEndOfLine() => isEndOfFile() || peek().char == '\n';
  bool isEndOfFile() => !hasCharAt(cursor.position);

  bool hasCharAt(final int position) => position < length;
  String charAt(final int position) =>
      hasCharAt(position) ? source[position] : '';

  String getCharactersAt(final int position, final int offset) =>
      List<String>.generate(offset, (final int i) => charAt(position + i))
          .join();

  void skipWhitespace() {
    while (!isEndOfFile() && BaizeLexerUtils.isWhitespace(peek().char)) {
      advance();
    }
  }

  int get length => source.length;

  static Future<BaizeInput> fromFile(final File file) async {
    final String source = await file.readAsString();
    return BaizeInput(source);
  }
}
