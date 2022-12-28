import '../errors/exports.dart';
import 'exports.dart';

class FubukiNumberValue extends FubukiPrimitiveObjectValue {
  FubukiNumberValue(this.value);

  final double value;

  int get unsafeIntValue => value.toInt();

  int get intValue {
    if (value % 1 == 0) return value.toInt();
    throw FubukiRuntimeExpection('Cannot convert "$value" to integer');
  }

  num get numValue {
    if (value % 1 == 0) return value.toInt();
    return value;
  }

  FubukiNumberValue get negate => FubukiNumberValue(-value);

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'sign':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(value.sign),
          );

        case 'isFinite':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(value.isFinite),
          );

        case 'isInfinite':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(value.isInfinite),
          );

        case 'isNaN':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(value.isNaN),
          );

        case 'isNegative':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(value.isNegative),
          );

        case 'abs':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(value.abs()),
          );

        case 'ceil':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(value.ceilToDouble()),
          );

        case 'round':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(value.roundToDouble()),
          );

        case 'truncate':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(value.truncateToDouble()),
          );

        case 'precisionString':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) => FubukiStringValue(
              value.toStringAsPrecision(
                call.argumentAt<FubukiNumberValue>(0).value.toInt(),
              ),
            ),
          );

        default:
      }
    }
    return super.get(key);
  }

  @override
  final FubukiValueKind kind = FubukiValueKind.number;

  @override
  FubukiNumberValue kClone() => FubukiNumberValue(value);

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
