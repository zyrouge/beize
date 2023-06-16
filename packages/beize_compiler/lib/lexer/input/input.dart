import 'dart:io';
import '../cursor.dart';
import '../utils.dart';
import 'iteration.dart';

class BeizeInput {
  BeizeInput(this.source);

  final String source;

  BeizeCursor cursor = const BeizeCursor();

  BeizeInputIteration advance() {
    final BeizeInputIteration previous = peek();
    final int position = cursor.position + 1;
    int row = cursor.row;
    int column = cursor.column + 1;

    if (isEndOfLine()) {
      row++;
      column = 0;
    }
    cursor = BeizeCursor(position: position, row: row, column: column);
    return previous;
  }

  BeizeInputIteration peek() =>
      BeizeInputIteration(charAt(cursor.position), cursor);

  bool isEndOfLine() => isEndOfFile() || peek().char == '\n';
  bool isEndOfFile() => !hasCharAt(cursor.position);

  bool hasCharAt(final int position) => position < length;
  String charAt(final int position) =>
      hasCharAt(position) ? source[position] : '';

  String getCharactersAt(final int position, final int offset) =>
      List<String>.generate(offset, (final int i) => charAt(position + i))
          .join();

  void skipWhitespace() {
    while (!isEndOfFile() && BeizeLexerUtils.isWhitespace(peek().char)) {
      advance();
    }
  }

  int get length => source.length;

  static Future<BeizeInput> fromFile(final File file) async {
    final String source = await file.readAsString();
    return BeizeInput(source);
  }
}
