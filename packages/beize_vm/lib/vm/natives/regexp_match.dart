import '../../values/exports.dart';
import '../exports.dart';

class BeizeRegExpMatchValue extends BeizePrimitiveObjectValue {
  BeizeRegExpMatchValue(this.match);

  final RegExpMatch match;

  @override
  final String kName = 'RegExpMatch';

  @override
  BeizeValue getAlongFrame(final BeizeCallFrame frame, final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'input':
          return BeizeStringValue(match.input);

        case 'groupCount':
          return BeizeNumberValue(match.groupCount.toDouble());

        case 'groupNames':
          return BeizeListValue(
            match.groupNames
                .map((final String x) => BeizeStringValue(x))
                .toList(),
          );
      }
    }
    return super.get(key);
  }

  @override
  BeizeRegExpMatchClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.natives.globals.regExpMatchClass;

  @override
  BeizeRegExpMatchValue kClone() => BeizeRegExpMatchValue(match);

  @override
  String kToString() => '<regexp match>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => match.hashCode;
}
