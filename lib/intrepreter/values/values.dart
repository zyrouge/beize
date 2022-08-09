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
  internalReturnValue,
  internalBreakValue,
  interalContinueValue,
}

abstract class OutreValueProperties {
  static const OutreValuePropertyKey kUnaryPlus = 'positive';
  static const OutreValuePropertyKey kUnaryMinus = 'negative';
  static const OutreValuePropertyKey kUnaryNegate = 'negate';
  static const OutreValuePropertyKey kAdd = 'add';
  static const OutreValuePropertyKey kSubtract = 'subtract';
  static const OutreValuePropertyKey kMultiply = 'multiply';
  static const OutreValuePropertyKey kPow = 'pow';
  static const OutreValuePropertyKey kDivide = 'divide';
  static const OutreValuePropertyKey kFloorDivide = 'floorDivide';
  static const OutreValuePropertyKey kModulo = 'modulo';

  static const OutreValuePropertyKey kValueOf = 'valueOf';
  static const OutreValuePropertyKey kToString = 'toString';
}

typedef OutreValuePropertyKey = dynamic;

abstract class OutreValue {
  OutreValue(this.kind);

  final OutreValues kind;

  late final Map<OutreValuePropertyKey, OutreValue> defaultProperties =
      <OutreValuePropertyKey, OutreValue>{
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
      properties[key] ?? defaultProperties[key] ?? OutreNullValue.value;

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
