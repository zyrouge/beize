import '../../values/exports.dart';
import '../exports.dart';

abstract class BeizeRegExpNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('new'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue value = call.argumentAt(0);
          final BeizeValue flags = call.argumentAt(1);
          return newRegExp(
            value.value,
            flags is BeizeNullValue ? '' : flags.cast<BeizeStringValue>().value,
          );
        },
      ),
    );
    namespace.declare('RegExp', value);
  }

  static BeizeValue newRegExp(final String patternValue, final String flags) {
    final RegExp regex = RegExp(
      patternValue,
      caseSensitive: !flags.contains('i'),
      dotAll: flags.contains('s'),
      multiLine: flags.contains('m'),
      unicode: flags.contains('u'),
    );
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('isCaseInsensitive'),
      BeizeBooleanValue(!regex.isCaseSensitive),
    );
    value.set(
      BeizeStringValue('isDotAll'),
      BeizeBooleanValue(regex.isDotAll),
    );
    value.set(
      BeizeStringValue('isMultiLine'),
      BeizeBooleanValue(regex.isMultiLine),
    );
    value.set(
      BeizeStringValue('isUnicode'),
      BeizeBooleanValue(regex.isUnicode),
    );
    value.set(
      BeizeStringValue('pattern'),
      BeizeStringValue(regex.pattern),
    );
    value.set(
      BeizeStringValue('hasMatch'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          return BeizeBooleanValue(regex.hasMatch(input.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('stringMatch'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final String? match = regex.stringMatch(input.value);
          return match is String
              ? BeizeStringValue(match)
              : BeizeNullValue.value;
        },
      ),
    );
    value.set(
      BeizeStringValue('firstMatch'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final RegExpMatch? match = regex.firstMatch(input.value);
          return match is RegExpMatch
              ? newRegExpMatch(match)
              : BeizeNullValue.value;
        },
      ),
    );
    value.set(
      BeizeStringValue('allMatches'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final Iterable<RegExpMatch> matches = regex.allMatches(input.value);
          return BeizeListValue(matches.map(newRegExpMatch).toList());
        },
      ),
    );
    value.set(
      BeizeStringValue('replaceFirst'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final BeizeStringValue to = call.argumentAt(1);
          return BeizeStringValue(
            input.value.replaceFirst(regex, to.value),
          );
        },
      ),
    );
    value.set(
      BeizeStringValue('replaceAll'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final BeizeStringValue to = call.argumentAt(1);
          return BeizeStringValue(
            input.value.replaceAll(regex, to.value),
          );
        },
      ),
    );
    value.set(
      BeizeStringValue('replaceFirstMapped'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue result = replaceMapped(regex, call, 1);
          return result;
        },
      ),
    );
    value.set(
      BeizeStringValue('replaceAllMapped'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue result = replaceMapped(regex, call);
          return result;
        },
      ),
    );
    return value;
  }

  static BeizeValue newRegExpMatch(final RegExpMatch match) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('input'),
      BeizeStringValue(match.input),
    );
    value.set(
      BeizeStringValue('groupCount'),
      BeizeNumberValue(match.groupCount.toDouble()),
    );
    value.set(
      BeizeStringValue('groupNames'),
      BeizeListValue(
        match.groupNames.map((final String x) => BeizeStringValue(x)).toList(),
      ),
    );
    value.set(
      BeizeStringValue('namedGroup'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final String? result = match.namedGroup(input.value);
          return result is String
              ? BeizeStringValue(result)
              : BeizeNullValue.value;
        },
      ),
    );
    value.set(
      BeizeStringValue('group'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeNumberValue input = call.argumentAt(0);
          final String? result = match.group(input.intValue);
          return result is String
              ? BeizeStringValue(result)
              : BeizeNullValue.value;
        },
      ),
    );
    return value;
  }

  static BeizeStringValue replaceMapped(
    final RegExp regex,
    final BeizeNativeFunctionCall call, [
    final int? count,
  ]) {
    final BeizeStringValue input = call.argumentAt(0);
    final BeizeCallableValue mapper = call.argumentAt(1);
    final String result = input.replacePatternMapped(
      regex,
      (final Match match) {
        final BeizeValue result = call.frame.callValue(
          mapper,
          <BeizeValue>[newRegExpMatch(match as RegExpMatch)],
        ).unwrapUnsafe();
        return result.cast<BeizeStringValue>().value;
      },
      count: count,
    );
    return BeizeStringValue(result);
  }
}
