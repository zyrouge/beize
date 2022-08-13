import 'exports.dart';

abstract class OutreBooleanValueProperties {}

class OutreBooleanValue extends OutreValue {
  // ignore: avoid_positional_boolean_parameters
  factory OutreBooleanValue(final bool value) =>
      value ? _trueValue : _falseValue;

  // ignore: avoid_positional_boolean_parameters
  OutreBooleanValue._(this.value) : super(OutreValues.booleanValue);

  final bool value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kUnaryNegate:
        OutreBooleanValue._(!value).asOutreFunctionValue(),
    OutreValueProperties.kLogicalAnd:
        _binary((final bool other) => value && other),
    OutreValueProperties.kLogicalOr:
        _binary((final bool other) => value || other),
    OutreValueProperties.kToString:
        OutreStringValue(value.toString()).asOutreFunctionValue(),
  };

  OutreFunctionValue _binary(
    final bool Function(bool) fn,
  ) =>
      OutreFunctionValue(
        (final List<OutreValue> arguments) async => OutreBooleanValue(
          fn(arguments.first.cast<OutreBooleanValue>().value),
        ),
      );

  static final OutreBooleanValue _trueValue = OutreBooleanValue._(true);
  static final OutreBooleanValue _falseValue = OutreBooleanValue._(false);
}
