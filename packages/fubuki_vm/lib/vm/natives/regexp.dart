import '../../values/exports.dart';
import '../call_frame.dart';
import '../namespace.dart';

abstract class FubukiRegExpNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('new'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue value = call.argumentAt(0);
          final FubukiValue flags = call.argumentAt(1);
          return newRegExp(
            value.value,
            flags is FubukiNullValue
                ? ''
                : flags.cast<FubukiStringValue>().value,
          );
        },
      ),
    );
    namespace.declare('RegExp', value);
  }

  static FubukiValue newRegExp(final String patternValue, final String flags) {
    final RegExp regex = RegExp(
      patternValue,
      caseSensitive: !flags.contains('i'),
      dotAll: flags.contains('s'),
      multiLine: flags.contains('m'),
      unicode: flags.contains('u'),
    );
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('isCaseInsensitive'),
      FubukiBooleanValue(!regex.isCaseSensitive),
    );
    value.set(
      FubukiStringValue('isDotAll'),
      FubukiBooleanValue(regex.isDotAll),
    );
    value.set(
      FubukiStringValue('isMultiLine'),
      FubukiBooleanValue(regex.isMultiLine),
    );
    value.set(
      FubukiStringValue('isUnicode'),
      FubukiBooleanValue(regex.isUnicode),
    );
    value.set(
      FubukiStringValue('pattern'),
      FubukiStringValue(regex.pattern),
    );
    value.set(
      FubukiStringValue('hasMatch'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          return FubukiBooleanValue(regex.hasMatch(input.value));
        },
      ),
    );
    value.set(
      FubukiStringValue('stringMatch'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          final String? match = regex.stringMatch(input.value);
          return match is String
              ? FubukiStringValue(match)
              : FubukiNullValue.value;
        },
      ),
    );
    value.set(
      FubukiStringValue('firstMatch'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          final RegExpMatch? match = regex.firstMatch(input.value);
          return match is RegExpMatch
              ? newRegExpMatch(match)
              : FubukiNullValue.value;
        },
      ),
    );
    value.set(
      FubukiStringValue('allMatches'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          final Iterable<RegExpMatch> matches = regex.allMatches(input.value);
          return FubukiListValue(matches.map(newRegExpMatch).toList());
        },
      ),
    );
    value.set(
      FubukiStringValue('replaceFirst'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          final FubukiStringValue to = call.argumentAt(1);
          return FubukiStringValue(
            input.value.replaceFirst(regex, to.value),
          );
        },
      ),
    );
    value.set(
      FubukiStringValue('replaceAll'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          final FubukiStringValue to = call.argumentAt(1);
          return FubukiStringValue(
            input.value.replaceAll(regex, to.value),
          );
        },
      ),
    );
    value.set(
      FubukiStringValue('replaceFirstMapped'),
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final FubukiStringValue result = await replaceMapped(regex, call, 1);
          return result;
        },
      ),
    );
    value.set(
      FubukiStringValue('replaceAllMapped'),
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final FubukiStringValue result = await replaceMapped(regex, call);
          return result;
        },
      ),
    );
    return value;
  }

  static FubukiValue newRegExpMatch(final RegExpMatch match) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('input'),
      FubukiStringValue(match.input),
    );
    value.set(
      FubukiStringValue('groupCount'),
      FubukiNumberValue(match.groupCount.toDouble()),
    );
    value.set(
      FubukiStringValue('groupNames'),
      FubukiListValue(
        match.groupNames.map((final String x) => FubukiStringValue(x)).toList(),
      ),
    );
    value.set(
      FubukiStringValue('namedGroup'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue input = call.argumentAt(0);
          final String? result = match.namedGroup(input.value);
          return result is String
              ? FubukiStringValue(result)
              : FubukiNullValue.value;
        },
      ),
    );
    value.set(
      FubukiStringValue('group'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiNumberValue input = call.argumentAt(0);
          final String? result = match.group(input.intValue);
          return result is String
              ? FubukiStringValue(result)
              : FubukiNullValue.value;
        },
      ),
    );
    return value;
  }

  static Future<FubukiStringValue> replaceMapped(
    final RegExp regex,
    final FubukiNativeFunctionCall call, [
    final int? count,
  ]) async {
    final FubukiStringValue input = call.argumentAt(0);
    final FubukiFunctionValue mapper = call.argumentAt(1);
    final String result = await input.replacePatternMapped(
      regex,
      (final Match match) async {
        final FubukiValue result = await call.frame.callValue(
          mapper,
          <FubukiValue>[newRegExpMatch(match as RegExpMatch)],
        ).unwrapUnsafe();
        return result.cast<FubukiStringValue>().value;
      },
      count: count,
    );
    return FubukiStringValue(result);
  }
}
