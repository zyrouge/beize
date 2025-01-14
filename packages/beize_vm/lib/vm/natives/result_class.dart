import '../../values/exports.dart';
import '../exports.dart';

class BeizeResultClassValue extends BeizePrimitiveClassValue {
  @override
  final String kName = 'ResultClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeBytesListValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeBooleanValue success = call.argumentAt(0);
    final BeizeBooleanValue value = call.argumentAt(1);
    final BeizeBooleanValue error = call.argumentAt(2);
    return BeizeInterpreterResult.success(
      BeizeResultValue(success.value, value, error),
    );
  }

  @override
  String kToString() => '<result class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
