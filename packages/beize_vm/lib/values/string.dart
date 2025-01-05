import '../vm/exports.dart';
import 'exports.dart';

class BeizeStringValue extends BeizePrimitiveObjectValue {
  BeizeStringValue(this.value);

  final String value;

  @override
  final String kName = 'String';

  BeizeStringValue replaceMapped(
    final BeizeFunctionCall call, [
    final int? count,
  ]) {
    final BeizeStringValue pattern = call.argumentAt(0);
    final BeizeCallableValue mapper = call.argumentAt(1);
    final String result = replacePatternMapped(
      pattern.value,
      (final Match match) {
        final BeizeValue result = call.frame.callValue(
          mapper,
          <BeizeValue>[BeizeStringValue(match.group(0)!)],
        ).unwrapUnsafe();
        return result.cast<BeizeStringValue>().value;
      },
      count: count,
    );
    return BeizeStringValue(result);
  }

  String replacePatternMapped(
    final Pattern pattern,
    final String Function(Match) mapper, {
    final int? count,
  }) {
    String result = value;
    int adjuster = 0;
    int i = 0;
    for (final Match x in pattern.allMatches(result)) {
      if (count != null && i >= count) break;
      final String by = mapper(x);
      final String nResult = result.replaceRange(
        x.start + adjuster,
        x.end + adjuster,
        by,
      );
      adjuster = nResult.length - result.length;
      result = nResult;
      i++;
    }
    return result;
  }

  String format(final BeizePrimitiveObjectValue env) {
    if (env is BeizeListValue) {
      int i = 0;
      return value.replaceAllMapped(
        RegExp(r'(?<!\\){([^}]*)}'),
        (final Match match) {
          final String key = match[1]!;
          if (key.isEmpty) {
            return env.getIndex(i++).kToString();
          }
          return env.getIndex(int.parse(key)).kToString();
        },
      );
    }
    final String result = value.replaceAllMapped(
      RegExp(r'(?<!\\){([^}]+)}'),
      (final Match match) {
        final String key = match[1]!;
        return env.get(BeizeStringValue(key)).kToString();
      },
    );
    return result;
  }

  @override
  BeizeStringClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.stringClass;

  @override
  bool kEquals(final BeizeValue other) =>
      other is BeizeStringValue && value == other.value;

  @override
  BeizeStringValue kClone() => BeizeStringValue(value);

  @override
  String kToString() => value;

  @override
  bool get isTruthy => value.isNotEmpty;

  @override
  int get kHashCode => value.hashCode;
}
