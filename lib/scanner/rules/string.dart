import '../../lexer/exports.dart';
import '../scanner.dart';
import '../utils.dart';

abstract class OutreStringScanner {
  static bool matches(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) =>
      OutreLexerUtils.isQuote(current.char) ||
      (current.char == 'r' &&
          OutreLexerUtils.isQuote(scanner.input.peek().char));

  static OutreToken readString(
    final OutreScanner scanner,
    final OutreInputIteration current,
  ) {
    final OutreSpanPoint start = current.point;
    final bool isRaw = current.char == 'r';
    if (isRaw) {
      final String delimiter = scanner.input.advance().char;
      return readRawString(scanner, delimiter, start);
    }

    return processString(readRawString(scanner, current.char, start));
  }

  static OutreToken processString(final OutreToken token) {
    final String literal = token.literal as String;
    final int length = literal.length;
    final OutreStrictStringBuffer buffer = OutreStrictStringBuffer();

    bool escaped = false;
    int i = 0;
    int row = 0;
    int column = 0;
    while (i < length) {
      final String char = literal[i];
      i++;
      column++;

      if (!escaped && char == r'\') {
        escaped = true;
        continue;
      }

      if (!escaped) {
        buffer.write(char);
        continue;
      }

      switch (char) {
        case r'\':
          buffer.write(r'\');
          break;

        case 't':
          buffer.write('\t');
          break;

        case 'r':
          buffer.write('\r');
          break;

        case 'n':
          buffer.write('\n');
          break;

        case 'f':
          buffer.write('\f');
          break;

        case 'b':
          buffer.write('\b');
          break;

        case 'v':
          buffer.write('\v');
          break;

        case 'u':
          final int end = i + 4;
          if (end < length) {
            final String digit = literal.substring(i, end);
            final int? parsed = int.tryParse(digit, radix: 16);
            if (parsed != null) {
              buffer.write(String.fromCharCode(parsed));
              i = end;
              break;
            }
          }

          return OutreToken(
            OutreTokens.illegal,
            buffer.toString(),
            token.span,
            error: 'Invalid unicode escape sequence',
            errorSpan: OutreSpan(
              token.span.start.add(
                position: i,
                row: row,
                column: column,
              ),
              token.span.start.add(
                position: end,
                row: row,
                column: column + 4,
              ),
            ),
          );

        case 'x':
          final int end = i + 2;
          if (end < length) {
            final String digit = literal.substring(i, end);
            final int? parsed = int.tryParse(digit, radix: 16);
            if (parsed != null) {
              buffer.write(String.fromCharCode(parsed));
              i = end;
              break;
            }
          }

          return OutreToken(
            OutreTokens.illegal,
            buffer.toString(),
            token.span,
            error: 'Invalid unicode escape sequence',
            errorSpan: OutreSpan(
              token.span.start.add(
                position: i,
                row: row,
                column: column,
              ),
              token.span.start.add(
                position: end,
                row: row,
                column: column + 2,
              ),
            ),
          );

        default:
          if (char == '\n') {
            row++;
            column = 0;
          }
          buffer.write(char);
      }
      escaped = false;
    }

    return OutreToken(token.type, buffer.toString(), token.span);
  }

  static OutreToken readRawString(
    final OutreScanner scanner,
    final String delimiter,
    final OutreSpanPoint start,
  ) {
    final OutreStrictStringBuffer buffer = OutreStrictStringBuffer();

    bool finished = false;
    bool escaped = false;
    OutreSpanPoint end = start;

    while (!finished && !scanner.input.isEndOfFile()) {
      final OutreInputIteration current = scanner.input.advance();
      if (!escaped && current.char == delimiter) {
        finished = true;
        break;
      }
      escaped = !escaped && current.char == r'\';
      buffer.write(current.char);
      end = current.point;
    }

    final String output = buffer.toString();
    if (!finished) {
      return OutreToken(
        OutreTokens.illegal,
        output,
        OutreSpan(start, end),
        error: 'Unterminated string literal',
      );
    }

    return OutreToken(OutreTokens.string, output, OutreSpan(start, end));
  }
}
