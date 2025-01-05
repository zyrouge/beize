import '../../values/exports.dart';
import '../exports.dart';

class BeizeRegExpClassValue extends BeizePrimitiveClassValue {
  BeizeRegExpClassValue() {
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'RegExpClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeBytesListValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeStringValue pattern = call.argumentAt(0);
    final String flags = call.argumentAtIs<BeizeNullValue>(1)
        ? ''
        : call.argumentAt<BeizeStringValue>(1).value;
    final RegExp regexp = RegExp(
      pattern.value,
      caseSensitive: !flags.contains('i'),
      dotAll: flags.contains('s'),
      multiLine: flags.contains('m'),
      unicode: flags.contains('u'),
    );
    return BeizeInterpreterResult.success(BeizeRegExpValue(regexp));
  }

  @override
  String kToString() => '<regexp class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('hasMatch'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(1);
          return BeizeBooleanValue(
            call.frame.vm.globals,
            object.regexp.hasMatch(input.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('stringMatch'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(1);
          final String? match = object.regexp.stringMatch(input.value);
          return match is String
              ? BeizeStringValue(match)
              : BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('firstMatch'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(1);
          final RegExpMatch? match = object.regexp.firstMatch(input.value);
          return match is RegExpMatch
              ? BeizeRegExpMatchValue(match)
              : BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('allMatches'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(1);
          final Iterable<RegExpMatch> matches =
              object.regexp.allMatches(input.value);
          return BeizeListValue(
            matches
                .map((final RegExpMatch x) => BeizeRegExpMatchValue(x))
                .toList(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceFirst'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(1);
          final BeizeStringValue to = call.argumentAt(2);
          return BeizeStringValue(
            input.value.replaceFirst(object.regexp, to.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceAll'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(1);
          final BeizeStringValue to = call.argumentAt(2);
          return BeizeStringValue(
            input.value.replaceAll(object.regexp, to.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceFirstMapped'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue result = object.replaceMapped(call, 1);
          return result;
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceAllMapped'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpValue object, final BeizeFunctionCall call) {
          final BeizeStringValue result = object.replaceMapped(call);
          return result;
        },
      ),
    );
  }
}
