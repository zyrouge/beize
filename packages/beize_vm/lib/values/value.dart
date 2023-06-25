import '../errors/exports.dart';
import 'exports.dart';

abstract class BeizeValue {
  BeizeValueKind get kind;

  String kToString();
  bool kEquals(final BeizeValue other) => other.kHashCode == kHashCode;

  T cast<T extends BeizeValue>() {
    if (canCast<T>()) return this as T;
    throw BeizeRuntimeExpection.cannotCastTo(getKindFromType(T), kind);
  }

  bool canCast<T extends BeizeValue>() {
    if (T == BeizeValue) return true;
    if (T == BeizePrimitiveObjectValue) {
      return this is BeizePrimitiveObjectValue;
    }
    if (T == BeizeCallableValue) {
      return this is BeizeCallableValue;
    }
    final BeizeValueKind to = getKindFromType(T);
    if (kind == to) return true;
    return false;
  }

  bool get isTruthy;
  bool get isFalsey => !isTruthy;
  int get kHashCode;

  @override
  String toString() => 'Beize${kind.code}Value: ${kToString()}';

  static final Map<Type, BeizeValueKind> _typeKindMap = <Type, BeizeValueKind>{
    BeizeBooleanValue: BeizeValueKind.boolean,
    BeizeFunctionValue: BeizeValueKind.function,
    BeizeListValue: BeizeValueKind.list,
    BeizeNativeFunctionValue: BeizeValueKind.nativeFunction,
    BeizeNullValue: BeizeValueKind.nullValue,
    BeizeNumberValue: BeizeValueKind.number,
    BeizeObjectValue: BeizeValueKind.object,
    BeizeStringValue: BeizeValueKind.string,
    BeizeModuleValue: BeizeValueKind.module,
    BeizePrimitiveObjectValue: BeizeValueKind.primitiveObject,
    BeizeExceptionValue: BeizeValueKind.exception,
  };

  static BeizeValueKind getKindFromType(final Type type) => _typeKindMap[type]!;
}
