abstract class OutreUtils {
  static const String tab = '   ';

  static List<String> withIndexPrefix(final List<String> lines) => lines
      .asMap()
      .map((final int i, final String x) => MapEntry<int, String>(i, '$i. $x'))
      .values
      .toList();

  static String indentLines(
    final List<String> input,
    final int indent, [
    final String tab = tab,
  ]) =>
      input.map((final String x) => '${tab * indent} $x').join('\n');

  static String indent(
    final String input,
    final int indent, [
    final String tab = tab,
  ]) =>
      indentLines(input.split('\n'), indent);

  static T findEnum<T extends Enum>(
    final List<T> values,
    final String value,
  ) =>
      values.firstWhere((final T x) => x.name == value);

  static String pascalToKebabCase(final String value) => value.replaceAllMapped(
        RegExp('[A-Z]'),
        (final Match x) => '-${x.group(0)!.toLowerCase()}',
      );

  static String kebabToPascalCase(final String value) => value.replaceAllMapped(
        RegExp(r'-(\w{1})'),
        (final Match x) => x.group(1)!.toUpperCase(),
      );

  static T? getListIndexNullable<T>(
    final List<T> elements,
    final int index,
  ) =>
      index < elements.length ? elements[index] : null;
}
