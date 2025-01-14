import '../../values/exports.dart';
import '../exports.dart';

class BeizeResultValue extends BeizePrimitiveObjectValue {
  BeizeResultValue(this.success, this.value, this.error);

  final bool success;
  final BeizeValue value;
  final BeizeValue error;

  @override
  final String kName = 'Result';

  @override
  BeizeValue getAlongFrame(final BeizeCallFrame frame, final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'success':
          return BeizeBooleanValue(frame.vm.globals, success);

        case 'value':
          return value;

        case 'error':
          return error;
      }
    }
    return super.getAlongFrame(frame, key);
  }

  @override
  BeizeResultClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.natives.globals.resultClass;

  @override
  BeizeResultValue kClone() => BeizeResultValue(success, value, error);

  @override
  String kToString() => '<result>';

  @override
  bool get isTruthy => success;

  @override
  int get kHashCode => Object.hash(success, value.kHashCode, error.kHashCode);
}
