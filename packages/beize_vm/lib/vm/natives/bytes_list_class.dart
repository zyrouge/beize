import '../../values/exports.dart';
import '../exports.dart';

class BeizeBytesListClassValue extends BeizePrimitiveClassValue {
  BeizeBytesListClassValue() {
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'BytesListClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeBytesListValue;

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
  String kToString() => '<bytes list class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('bytes'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeBytesListValue object, final _) => BeizeListValue(
          object.bytes
              .map((final int x) => BeizeNumberValue(x.toDouble()))
              .toList(),
        ),
      ),
    );
  }
}
