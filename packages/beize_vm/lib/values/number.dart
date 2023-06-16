import '../errors/exports.dart';
import 'exports.dart';

class BeizeNumberValue extends BeizePrimitiveObjectValue {
  BeizeNumberValue(this.value);

  final double value;

  int get unsafeIntValue => value.toInt();

  int get intValue {
    if (value % 1 == 0) return value.toInt();
    throw BeizeRuntimeExpection('Cannot convert "$value" to integer');
  }

  num get numValue {
    if (value % 1 == 0) return value.toInt();
    return value;
  }

  BeizeNumberValue get negate => BeizeNumberValue(-value);

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'sign':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(value.sign),
          );

        case 'isFinite':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(value.isFinite),
          );

        case 'isInfinite':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(value.isInfinite),
          );

        case 'isNaN':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(value.isNaN),
          );

        case 'isNegative':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(value.isNegative),
          );

        case 'abs':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(value.abs()),
          );

        case 'ceil':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(value.ceilToDouble()),
          );

        case 'round':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(value.roundToDouble()),
          );

        case 'truncate':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(value.truncateToDouble()),
          );

        case 'precisionString':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) => BeizeStringValue(
              value.toStringAsPrecision(
                call.argumentAt<BeizeNumberValue>(0).value.toInt(),
              ),
            ),
          );

        case 'toRadixString':
          return BeizeNativeFunctionValue.sync(
            (final BeizeNativeFunctionCall call) => BeizeStringValue(
              intValue.toRadixString(
                call.argumentAt<BeizeNumberValue>(0).intValue,
              ),
            ),
          );

        default:
      }
    }
    return super.get(key);
  }

  @override
  final BeizeValueKind kind = BeizeValueKind.number;

  @override
  BeizeNumberValue kClone() => BeizeNumberValue(value);

  @override
  String kToString() {
    // Source: https://stackoverflow.com/a/59963834
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toString();
  }

  @override
  bool get isTruthy => value != 0;

  @override
  int get kHashCode => value.hashCode;
}
