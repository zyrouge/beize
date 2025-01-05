import '../vm/exports.dart';
import 'exports.dart';

class BeizeClassValue extends BeizePrimitiveClassValue {
  BeizeClassValue() {
    fields.set(
      BeizeStringValue('of'),
      BeizeNativeFunctionValue.boundSync(
        (
          final BeizePrimitiveObjectValue object,
          final BeizeFunctionCall call,
        ) =>
            object.kClass(call.frame),
      ),
    );
    fields.set(
      BeizeStringValue('instantiate'),
      BeizeNativeFunctionValue(
        (final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue object = call.argumentAt(0);
          final BeizeFunctionCall nCall = BeizeFunctionCall(
            frame: call.frame,
            arguments: call.arguments.sublist(1),
          );
          return object.kClass(call.frame).kCall(nCall);
        },
      ),
    );
  }

  @override
  final String kName = 'Class';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeClassValue;

  @override
  BeizeClassValue kClone() => BeizeClassValue();

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    throw UnimplementedError();
  }

  @override
  String kToString() => '<class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
