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
  interalMirroredValue,
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
  static const OutreValuePropertyKey kIndexAccessGet = '_indexAccessGet';
  static const OutreValuePropertyKey kIndexAccessSet = '_indexAccessSet';

  static const OutreValuePropertyKey kKeys = '_keys';
  static const OutreValuePropertyKey kValues = '_values';
  static const OutreValuePropertyKey kEntries = '_entries';

  static const OutreValuePropertyKey kAwait = 'await';
  static const OutreValuePropertyKey kValueOf = 'valueOf';
  static const OutreValuePropertyKey kToString = 'toString';
}

typedef OutreValuePropertyKey = dynamic;

abstract class OutreValue {
  OutreValue(this.kind);

  final OutreValues kind;

  late final Map<OutreValuePropertyKey, OutreValue> defaultProperties =
      <OutreValuePropertyKey, OutreValue>{
    OutreValueProperties.kLogicalEqual: _equals,
    OutreValueProperties.kLogicalNotEqual: _notEquals,
    OutreValueProperties.kIndexAccessGet: _indexAccessGet,
    OutreValueProperties.kIndexAccessSet: _indexAccessSet,
    OutreValueProperties.kAwait: OutreFunctionValue.fromOutreValue(this),
    OutreValueProperties.kValueOf: OutreFunctionValue.fromOutreValue(this),
    OutreValueProperties.kToString: OutreFunctionValue.fromOutreValue(
      OutreStringValue(OutreTokens.objKw.code),
    ),
  };

  late final OutreFunctionValue _equals = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      final OutreValue a = this;
      final OutreValue b = call.argAt(0);
      return OutreBooleanValue(OutreValueUtils.equals(a, b));
    },
  );

  late final OutreFunctionValue _notEquals = OutreFunctionValue(
    (final OutreFunctionValueCall call) async => OutreBooleanValue(
      !(await getPropertyOfKey(OutreValueProperties.kLogicalEqual)
              .cast<OutreFunctionValue>()
              .call(call))
          .cast<OutreBooleanValue>()
          .value,
    ),
  );

  late final OutreFunctionValue _indexAccessGet = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      final OutreValue index = call.argAt(0);
      return getPropertyOfOutreValue(index);
    },
  );

  late final OutreFunctionValue _indexAccessSet = OutreFunctionValue(
    (final OutreFunctionValueCall call) async {
      final OutreValue index = call.argAt(0);
      final OutreValue value = call.argAt(1);
      setPropertyOfOutreValue(index, value);
      return OutreNullValue();
    },
  );

  void setPropertyOfOutreValue(
    final OutreValue name,
    final OutreValue value,
  ) =>
      setPropertyOfKey(getKeyFromOutreValue(name), value);

  void setPropertyOfKey(
    final OutreValuePropertyKey key,
    final OutreValue value,
  );

  OutreValue getPropertyOfOutreValue(final OutreValue name) =>
      getPropertyOfKey(getKeyFromOutreValue(name));

  OutreValue getPropertyOfKey(final OutreValuePropertyKey key);

  OutreValue getDefaultPropertyOfKey(final OutreValuePropertyKey key) =>
      defaultProperties[key] ?? OutreNullValue();

  OutreFunctionValue asOutreFunctionValue() =>
      OutreFunctionValue.fromOutreValue(this);

  T cast<T extends OutreValue>() => this as T;

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

  static OutreValue convertKeyToOutreValue(
    final OutreValuePropertyKey key,
  ) {
    if (key is bool) {
      return OutreBooleanValue(key);
    }
    if (key is double) {
      return OutreNumberValue(key);
    }
    if (key is String) {
      return OutreStringValue(key);
    }
    throw Exception('Invalid key type');
  }

  static List<OutreValue> getKeysFromOutreObjectProperties(
    final Map<OutreValuePropertyKey, OutreValue> properties,
  ) =>
      properties.keys.map(convertKeyToOutreValue).toList();

  static List<OutreValue> getValuesFromOutreObjectProperties(
    final Map<OutreValuePropertyKey, OutreValue> properties,
  ) =>
      properties.values.toList();

  static List<OutreValue> getEntriesFromOutreObjectProperties(
    final Map<OutreValuePropertyKey, OutreValue> properties,
  ) =>
      properties.entries
          .map(
            (final MapEntry<OutreValuePropertyKey, OutreValue> x) =>
                OutreArrayValue(
              <OutreValue>[convertKeyToOutreValue(x.key), x.value],
            ),
          )
          .toList();
}

abstract class OutreValueFromProperties extends OutreValue {
  OutreValueFromProperties(super.kind);

  @override
  void setPropertyOfKey(
    final OutreValuePropertyKey key,
    final OutreValue value,
  ) {
    properties[key] = value;
  }

  @override
  OutreValue getPropertyOfKey(final OutreValuePropertyKey key) =>
      properties[key] ?? getDefaultPropertyOfKey(key);

  Map<OutreValuePropertyKey, OutreValue> get properties;
}

mixin OutreConvertableValue {
  OutreValue toOutreValue();
}
