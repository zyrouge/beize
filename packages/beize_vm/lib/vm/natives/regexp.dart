import '../../values/exports.dart';
import '../exports.dart';

class BeizeRegExpValue extends BeizePrimitiveObjectValue {
  BeizeRegExpValue(this.regexp);

  final RegExp regexp;

  @override
  final String kName = 'RegExp';

  @override
  BeizeValue getAlongFrame(final BeizeCallFrame frame, final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'isCaseInsensitive':
          return BeizeBooleanValue(frame.vm.globals, !regexp.isCaseSensitive);

        case 'isDotAll':
          return BeizeBooleanValue(frame.vm.globals, regexp.isDotAll);

        case 'isMultiLine':
          return BeizeBooleanValue(frame.vm.globals, regexp.isMultiLine);

        case 'isUnicode':
          return BeizeBooleanValue(frame.vm.globals, regexp.isUnicode);

        case 'pattern':
          return BeizeStringValue(regexp.pattern);
      }
    }
    return super.get(key);
  }

  BeizeStringValue replaceMapped(
    final BeizeFunctionCall call, [
    final int? count,
  ]) {
    final BeizeStringValue input = call.argumentAt(0);
    final BeizeCallableValue mapper = call.argumentAt(1);
    final String result = input.replacePatternMapped(
      regexp,
      (final Match match) {
        final BeizeValue result = call.frame.callValue(
          mapper,
          <BeizeValue>[BeizeRegExpMatchValue(match as RegExpMatch)],
        ).unwrapUnsafe();
        return result.cast<BeizeStringValue>().value;
      },
      count: count,
    );
    return BeizeStringValue(result);
  }

  @override
  BeizeRegExpClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.natives.globals.regExpClass;

  @override
  bool kEquals(final BeizeValue other) =>
      other is BeizeRegExpValue && regexp.pattern == other.regexp.pattern;

  @override
  BeizeRegExpValue kClone() => BeizeRegExpValue(regexp);

  @override
  String kToString() => '<regexp>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => regexp.hashCode;
}
