import '../../values/exports.dart';
import '../exports.dart';

class BeizeDateTimeClassValue extends BeizePrimitiveClassValue {
  BeizeDateTimeClassValue() {
    bindClassFields(fields);
  }

  @override
  final String kName = 'DateTimeClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeDateTimeValue;

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
  String kToString() => '<datetime class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('fromMillisecondsSinceEpoch'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeNumberValue ms = call.argumentAt(0);
          return BeizeDateTimeValue(
            DateTime.fromMillisecondsSinceEpoch(ms.intValue),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('parse'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeStringValue value = call.argumentAt(0);
          return BeizeDateTimeValue(DateTime.parse(value.value));
        },
      ),
    );
    fields.set(
      BeizeStringValue('now'),
      BeizeNativeFunctionValue.sync(
        (final _) => BeizeDateTimeValue(DateTime.now()),
      ),
    );
  }
}
