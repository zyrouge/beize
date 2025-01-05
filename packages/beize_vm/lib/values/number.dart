import '../errors/exports.dart';
import '../vm/exports.dart';
import 'exports.dart';

class BeizeNumberValue extends BeizePrimitiveObjectValue {
  BeizeNumberValue(this.value);

  final double value;

  @override
  final String kName = 'Number';

  int get unsafeIntValue => value.toInt();

  int get intValue {
    if (value % 1 == 0) return value.toInt();
    throw BeizeRuntimeException.cannotConvertDoubleToInteger(value);
  }

  num get numValue {
    if (value % 1 == 0) return value.toInt();
    return value;
  }

  BeizeNumberValue get negate => BeizeNumberValue(-value);

  @override
  BeizeNumberClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.numberClass;

  @override
  bool kEquals(final BeizeValue other) =>
      other is BeizeNumberValue && value == other.value;

  @override
  BeizeNumberValue kClone() => BeizeNumberValue(value);

  @override
  String kToString() {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toString();
  }

  @override
  bool get isTruthy => value != 0;

  @override
  int get kHashCode => value.hashCode;
}
