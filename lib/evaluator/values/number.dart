import 'dart:math';
import 'exports.dart';

abstract class OutreNumberValueProperties {
  static const OutreValuePropertyKey kAbs = 'abs';
  static const OutreValuePropertyKey kCeil = 'ceil';
  static const OutreValuePropertyKey kTrunc = 'trunc';
  static const OutreValuePropertyKey kFloor = 'floor';
  static const OutreValuePropertyKey kIsFinite = 'isFinite';
  static const OutreValuePropertyKey kIsInfinite = 'isInfinite';
  static const OutreValuePropertyKey kIsPositive = 'isPositive';
  static const OutreValuePropertyKey kIsNegative = 'isNegative';
  static const OutreValuePropertyKey kSign = 'sign';
}

class OutreNumberValue extends OutreValue {
  OutreNumberValue(this.value) : super(OutreValues.numberValue);

  final double value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kAdd:
        _binaryDouble((final double other) => value + other),
    OutreValueProperties.kSubtract:
        _binaryDouble((final double other) => value - other),
    OutreValueProperties.kMultiply:
        _binaryDouble((final double other) => value * other),
    OutreValueProperties.kPow:
        _binaryDouble((final double other) => pow(value, other).toDouble()),
    OutreValueProperties.kDivide:
        _binaryDouble((final double other) => value / other),
    OutreValueProperties.kFloorDivide:
        _binaryDouble((final double other) => (value ~/ other).toDouble()),
    OutreValueProperties.kModulo:
        _binaryDouble((final double other) => value % other),
    OutreValueProperties.kBitwiseAnd: _binaryDouble(
      (final double other) => (value.toInt() & other.toInt()).toDouble(),
    ),
    OutreValueProperties.kBitwiseOr: _binaryDouble(
      (final double other) => (value.toInt() | other.toInt()).toDouble(),
    ),
    OutreValueProperties.kBitwiseXor: _binaryDouble(
      (final double other) => (value.toInt() ^ other.toInt()).toDouble(),
    ),
    OutreValueProperties.kLesserThan:
        _binaryBoolean((final double other) => value < other),
    OutreValueProperties.kLesserThanEqual:
        _binaryBoolean((final double other) => value <= other),
    OutreValueProperties.kGreaterThan:
        _binaryBoolean((final double other) => value > other),
    OutreValueProperties.kGreaterThanEqual:
        _binaryBoolean((final double other) => value >= other),
    OutreValueProperties.kBitwiseInvert: _staticDouble(-(value + 1)),
    OutreValueProperties.kUnaryPlus: _staticDouble(value),
    OutreValueProperties.kUnaryMinus: _staticDouble(-value),
    OutreNumberValueProperties.kCeil: _staticDouble(value.ceilToDouble()),
    OutreNumberValueProperties.kAbs: _staticDouble(value.abs()),
    OutreNumberValueProperties.kTrunc: _staticDouble(value.truncateToDouble()),
    OutreNumberValueProperties.kFloor: _staticDouble(value.floorToDouble()),
    OutreNumberValueProperties.kSign: _staticDouble(value.sign),
    OutreNumberValueProperties.kIsFinite: _staticBoolean(value.isFinite),
    OutreNumberValueProperties.kIsInfinite: _staticBoolean(value.isInfinite),
    OutreNumberValueProperties.kIsPositive: _staticBoolean(value > 0),
    OutreNumberValueProperties.kIsNegative: _staticBoolean(value.isNegative),
    OutreValueProperties.kToString:
        OutreStringValue(value.toString()).asOutreFunctionValue(),
  };

  OutreFunctionValue _staticDouble(final double value) =>
      OutreNumberValue(value).asOutreFunctionValue();

  OutreFunctionValue _staticBoolean(final bool value) =>
      OutreBooleanValue(value).asOutreFunctionValue();

  OutreFunctionValue _binaryDouble(
    final double Function(double) fn,
  ) =>
      OutreFunctionValue(
        1,
        (final List<OutreValue> arguments) => OutreNumberValue(
          fn(arguments.first.cast<OutreNumberValue>().value),
        ),
      );

  OutreFunctionValue _binaryBoolean(
    final bool Function(double) fn,
  ) =>
      OutreFunctionValue(
        1,
        (final List<OutreValue> arguments) => OutreBooleanValue(
          fn(arguments.first.cast<OutreNumberValue>().value),
        ),
      );
}
