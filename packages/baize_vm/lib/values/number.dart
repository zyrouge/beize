import '../errors/exports.dart';
import 'exports.dart';

class BaizeNumberValue extends BaizePrimitiveObjectValue {
  BaizeNumberValue(this.value);

  final double value;

  int get unsafeIntValue => value.toInt();

  int get intValue {
    if (value % 1 == 0) return value.toInt();
    throw BaizeRuntimeExpection('Cannot convert "$value" to integer');
  }

  num get numValue {
    if (value % 1 == 0) return value.toInt();
    return value;
  }

  BaizeNumberValue get negate => BaizeNumberValue(-value);

  @override
  BaizeValue get(final BaizeValue key) {
    if (key is BaizeStringValue) {
      switch (key.value) {
        case 'sign':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(value.sign),
          );

        case 'isFinite':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(value.isFinite),
          );

        case 'isInfinite':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(value.isInfinite),
          );

        case 'isNaN':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(value.isNaN),
          );

        case 'isNegative':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(value.isNegative),
          );

        case 'abs':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(value.abs()),
          );

        case 'ceil':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(value.ceilToDouble()),
          );

        case 'round':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(value.roundToDouble()),
          );

        case 'truncate':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(value.truncateToDouble()),
          );

        case 'precisionString':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) => BaizeStringValue(
              value.toStringAsPrecision(
                call.argumentAt<BaizeNumberValue>(0).value.toInt(),
              ),
            ),
          );

        case 'toRadixString':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) => BaizeStringValue(
              intValue.toRadixString(
                call.argumentAt<BaizeNumberValue>(0).intValue,
              ),
            ),
          );

        default:
      }
    }
    return super.get(key);
  }

  @override
  final BaizeValueKind kind = BaizeValueKind.number;

  @override
  BaizeNumberValue kClone() => BaizeNumberValue(value);

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
