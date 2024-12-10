class BeizeLexerUtils {
  static bool isWhitespace(final String char) => char.trim().isEmpty;
  static bool isNumeric(final String char) => '0123456789'.contains(char);
  static bool isNumericContent(final String char) =>
      '+-0123456789.exabcdef'.contains(char.toLowerCase());
  static bool isQuote(final String char) =>
      char == "'" || char == '"' || char == '`';
  static bool isAlpha(final String char) =>
      r'$_abcdefghijklmnopqrstuvwxyz'.contains(char.toLowerCase());
  static bool isAlphaNumeric(final String char) =>
      isAlpha(char) || isNumeric(char);
}
