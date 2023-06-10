import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeRegExpNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('new'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue value = call.argumentAt(0);
          final BaizeValue flags = call.argumentAt(1);
          return newRegExp(
            value.value,
            flags is BaizeNullValue
                ? ''
                : flags.cast<BaizeStringValue>().value,
          );
        },
      ),
    );
    namespace.declare('RegExp', value);
  }

  static BaizeValue newRegExp(final String patternValue, final String flags) {
    final RegExp regex = RegExp(
      patternValue,
      caseSensitive: !flags.contains('i'),
      dotAll: flags.contains('s'),
      multiLine: flags.contains('m'),
      unicode: flags.contains('u'),
    );
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('isCaseInsensitive'),
      BaizeBooleanValue(!regex.isCaseSensitive),
    );
    value.set(
      BaizeStringValue('isDotAll'),
      BaizeBooleanValue(regex.isDotAll),
    );
    value.set(
      BaizeStringValue('isMultiLine'),
      BaizeBooleanValue(regex.isMultiLine),
    );
    value.set(
      BaizeStringValue('isUnicode'),
      BaizeBooleanValue(regex.isUnicode),
    );
    value.set(
      BaizeStringValue('pattern'),
      BaizeStringValue(regex.pattern),
    );
    value.set(
      BaizeStringValue('hasMatch'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          return BaizeBooleanValue(regex.hasMatch(input.value));
        },
      ),
    );
    value.set(
      BaizeStringValue('stringMatch'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          final String? match = regex.stringMatch(input.value);
          return match is String
              ? BaizeStringValue(match)
              : BaizeNullValue.value;
        },
      ),
    );
    value.set(
      BaizeStringValue('firstMatch'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          final RegExpMatch? match = regex.firstMatch(input.value);
          return match is RegExpMatch
              ? newRegExpMatch(match)
              : BaizeNullValue.value;
        },
      ),
    );
    value.set(
      BaizeStringValue('allMatches'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          final Iterable<RegExpMatch> matches = regex.allMatches(input.value);
          return BaizeListValue(matches.map(newRegExpMatch).toList());
        },
      ),
    );
    value.set(
      BaizeStringValue('replaceFirst'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          final BaizeStringValue to = call.argumentAt(1);
          return BaizeStringValue(
            input.value.replaceFirst(regex, to.value),
          );
        },
      ),
    );
    value.set(
      BaizeStringValue('replaceAll'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          final BaizeStringValue to = call.argumentAt(1);
          return BaizeStringValue(
            input.value.replaceAll(regex, to.value),
          );
        },
      ),
    );
    value.set(
      BaizeStringValue('replaceFirstMapped'),
      BaizeNativeFunctionValue.async(
        (final BaizeNativeFunctionCall call) async {
          final BaizeStringValue result = await replaceMapped(regex, call, 1);
          return result;
        },
      ),
    );
    value.set(
      BaizeStringValue('replaceAllMapped'),
      BaizeNativeFunctionValue.async(
        (final BaizeNativeFunctionCall call) async {
          final BaizeStringValue result = await replaceMapped(regex, call);
          return result;
        },
      ),
    );
    return value;
  }

  static BaizeValue newRegExpMatch(final RegExpMatch match) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('input'),
      BaizeStringValue(match.input),
    );
    value.set(
      BaizeStringValue('groupCount'),
      BaizeNumberValue(match.groupCount.toDouble()),
    );
    value.set(
      BaizeStringValue('groupNames'),
      BaizeListValue(
        match.groupNames.map((final String x) => BaizeStringValue(x)).toList(),
      ),
    );
    value.set(
      BaizeStringValue('namedGroup'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue input = call.argumentAt(0);
          final String? result = match.namedGroup(input.value);
          return result is String
              ? BaizeStringValue(result)
              : BaizeNullValue.value;
        },
      ),
    );
    value.set(
      BaizeStringValue('group'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeNumberValue input = call.argumentAt(0);
          final String? result = match.group(input.intValue);
          return result is String
              ? BaizeStringValue(result)
              : BaizeNullValue.value;
        },
      ),
    );
    return value;
  }

  static Future<BaizeStringValue> replaceMapped(
    final RegExp regex,
    final BaizeNativeFunctionCall call, [
    final int? count,
  ]) async {
    final BaizeStringValue input = call.argumentAt(0);
    final BaizeFunctionValue mapper = call.argumentAt(1);
    final String result = await input.replacePatternMapped(
      regex,
      (final Match match) async {
        final BaizeValue result = await call.frame.callValue(
          mapper,
          <BaizeValue>[newRegExpMatch(match as RegExpMatch)],
        ).unwrapUnsafe();
        return result.cast<BaizeStringValue>().value;
      },
      count: count,
    );
    return BaizeStringValue(result);
  }
}
