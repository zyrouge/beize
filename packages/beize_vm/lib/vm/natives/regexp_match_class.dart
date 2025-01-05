import '../../values/exports.dart';
import '../exports.dart';

class BeizeRegExpMatchClassValue extends BeizePrimitiveClassValue {
  BeizeRegExpMatchClassValue() {
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'RegExpMatchClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeRegExpMatchValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    if (call.argumentAtIs<BeizeNullValue>(0)) {
      return BeizeInterpreterResult.success(BeizeBytesListValue(<int>[]));
    }
    final BeizeBytesListValue? bytesList = call.argumentAtOrNull(0);
    if (bytesList != null) {
      return BeizeInterpreterResult.success(bytesList.kClone());
    }
    final BeizeListValue list = call.argumentAt(0);
    final List<int> bytes = list.elements
        .map((final BeizeValue x) => x.cast<BeizeNumberValue>().intValue)
        .toList();
    return BeizeInterpreterResult.success(BeizeBytesListValue(bytes));
  }

  @override
  String kToString() => '<regexp match class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('namedGroup'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpMatchValue object, final BeizeFunctionCall call) {
          final BeizeStringValue input = call.argumentAt(0);
          final String? result = object.match.namedGroup(input.value);
          return result is String
              ? BeizeStringValue(result)
              : BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('group'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeRegExpMatchValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue input = call.argumentAt(0);
          final String? result = object.match.group(input.intValue);
          return result is String
              ? BeizeStringValue(result)
              : BeizeNullValue.value;
        },
      ),
    );
  }
}
