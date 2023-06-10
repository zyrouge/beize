import '../errors/exports.dart';
import 'exports.dart';

abstract class BaizeValue {
  BaizeValueKind get kind;

  String kToString();
  bool kEquals(final BaizeValue other) => other.kHashCode == kHashCode;

  T cast<T extends BaizeValue>() {
    if (canCast<T>()) return this as T;
    throw BaizeRuntimeExpection.cannotCastTo(getKindFromType(T), kind);
  }

  bool canCast<T extends BaizeValue>() {
    if (T == BaizeValue) return true;
    if (T == BaizePrimitiveObjectValue) {
      return this is BaizePrimitiveObjectValue;
    }
    final BaizeValueKind to = getKindFromType(T);
    if (kind == to) return true;
    return false;
  }

  bool get isTruthy;
  bool get isFalsey => !isTruthy;
  int get kHashCode;

  @override
  String toString() => 'Baize${kind.code}Value: ${kToString()}';

  static final Map<Type, BaizeValueKind> _typeKindMap =
      <Type, BaizeValueKind>{
    BaizeBooleanValue: BaizeValueKind.boolean,
    BaizeFunctionValue: BaizeValueKind.function,
    BaizeListValue: BaizeValueKind.list,
    BaizeNativeFunctionValue: BaizeValueKind.nativeFunction,
    BaizeNullValue: BaizeValueKind.nullValue,
    BaizeNumberValue: BaizeValueKind.number,
    BaizeObjectValue: BaizeValueKind.object,
    BaizeStringValue: BaizeValueKind.string,
    BaizeModuleValue: BaizeValueKind.module,
    BaizePrimitiveObjectValue: BaizeValueKind.primitiveObject,
  };

  static BaizeValueKind getKindFromType(final Type type) =>
      _typeKindMap[type]!;
}
