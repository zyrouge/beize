import '../../vm/exports.dart';
import '../exports.dart';

class BeizeUnawaitedClassValue extends BeizePrimitiveClassValue {
  BeizeUnawaitedClassValue() {
    bindClassFields(fields);
  }

  @override
  final String kName = 'UnawaitedClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeUnawaitedValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeUnawaitedClassValue value = call.argumentAt(0);
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<unawaited class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('value'),
      BeizeNativeFunctionValue.async(
        (final BeizeFunctionCall call) async {
          final BeizeValue value = call.argumentAt(0);
          return value;
        },
      ),
    );
  }
}
