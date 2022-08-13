import '../../lexer/exports.dart';
import 'exports.dart';

enum OutreValues {
  stringValue,
  numberValue,
  booleanValue,
  objectValue,
  functionValue,
  nullValue,
  arrayValue,
  promiseValue,
  internalReturnValue,
  internalBreakValue,
  interalContinueValue,
}

abstract class OutreValueProperties {
  static const OutreValuePropertyKey kUnaryPlus = '_positive';
  static const OutreValuePropertyKey kUnaryMinus = '_negative';
  static const OutreValuePropertyKey kUnaryNegate = '_negate';
  static const OutreValuePropertyKey kBitwiseInvert = '_bitwiseInvert';

  static const OutreValuePropertyKey kAdd = '_add';
  static const OutreValuePropertyKey kSubtract = '_subtract';
  static const OutreValuePropertyKey kMultiply = '_multiply';
  static const OutreValuePropertyKey kPow = '_pow';
  static const OutreValuePropertyKey kDivide = '_divide';
  static const OutreValuePropertyKey kFloorDivide = '_floorDivide';
  static const OutreValuePropertyKey kModulo = '_modulo';
  static const OutreValuePropertyKey kBitwiseAnd = '_bitwiseAnd';
  static const OutreValuePropertyKey kLogicalAnd = '_logicalAnd';
  static const OutreValuePropertyKey kBitwiseOr = '_bitwiseOr';
  static const OutreValuePropertyKey kLogicalOr = '_logicalOr';
  static const OutreValuePropertyKey kBitwiseXor = '_bitwiseXor';
  static const OutreValuePropertyKey kLogicalEqual = '_logicalEqual';
  static const OutreValuePropertyKey kLogicalNotEqual = '_logicalNotEqual';
  static const OutreValuePropertyKey kLesserThan = '_lesserThan';
  static const OutreValuePropertyKey kLesserThanEqual = '_lesserThanEqual';
  static const OutreValuePropertyKey kGreaterThan = '_greaterThan';
  static const OutreValuePropertyKey kGreaterThanEqual = '_greaterThanEqual';

  static const OutreValuePropertyKey kValueOf = 'valueOf';
  static const OutreValuePropertyKey kToString = 'toString';
}

typedef OutreValuePropertyKey = dynamic;

abstract class OutreValue {
  OutreValue(this.kind);

  final OutreValues kind;

  late final OutreFunctionValue _equals = OutreFunctionValue(
    (final List<OutreValue> arguments) async {
      final OutreValue a = this;
      final OutreValue b = arguments.first;
      return OutreBooleanValue(OutreValueUtils.equals(a, b));
    },
  );

  late final OutreFunctionValue _notEquals = OutreFunctionValue(
    (final List<OutreValue> arguments) async => OutreBooleanValue(
      !(await getPropertyOfKey(OutreValueProperties.kLogicalEqual)
              .cast<OutreFunctionValue>()
              .call(arguments))
          .cast<OutreBooleanValue>()
          .value,
    ),
  );

  late final Map<OutreValuePropertyKey, OutreValue> defaultProperties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kLogicalEqual: _equals,
    OutreValueProperties.kLogicalNotEqual: _notEquals,
    OutreValueProperties.kValueOf: OutreFunctionValue.fromOutreValue(this),
    OutreValueProperties.kToString: OutreFunctionValue.fromOutreValue(
      OutreStringValue(OutreTokens.objKw.code),
    ),
  };

  void setPropertyOfKey(
    final OutreValuePropertyKey key,
    final OutreValue value,
  ) {
    properties[key] = value;
  }

  void setPropertyOfOutreValue(
    final OutreValue name,
    final OutreValue value,
  ) {
    final OutreValuePropertyKey key = getKeyFromOutreValue(name);
    properties[key] = value;
  }

  OutreValue getPropertyOfKey(final OutreValuePropertyKey key) =>
      properties[key] ?? defaultProperties[key] ?? OutreNullValue();

  OutreValue getPropertyOfOutreValue(final OutreValue name) =>
      getPropertyOfKey(getKeyFromOutreValue(name));

  static OutreValuePropertyKey getKeyFromOutreValue(
    final OutreValue name,
  ) {
    switch (name.kind) {
      case OutreValues.booleanValue:
        return name.cast<OutreBooleanValue>().value;

      case OutreValues.numberValue:
        return name.cast<OutreNumberValue>().value;

      case OutreValues.stringValue:
        return name.cast<OutreStringValue>().value;

      default:
        throw Exception('Invalid key type');
    }
  }

  Map<OutreValuePropertyKey, OutreValue> get properties;

  OutreFunctionValue asOutreFunctionValue() =>
      OutreFunctionValue.fromOutreValue(this);

  T cast<T extends OutreValue>() => this as T;
}

mixin OutreConvertableValue {
  OutreValue toOutreValue();
}
