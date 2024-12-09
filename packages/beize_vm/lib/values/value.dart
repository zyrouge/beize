import '../errors/exports.dart';
import 'exports.dart';

abstract class BeizeValue {
  BeizeValueKind get kind;

  String kToString();
  bool kEquals(final BeizeValue other) => other.kHashCode == kHashCode;

  T cast<T extends BeizeValue>() {
    if (canCast<T>()) {
      return this as T;
    }
    throw BeizeRuntimeExpection.cannotCastTo(getKindFromType(T), kind);
  }

  bool canCast<T extends BeizeValue>() {
    if (T == BeizeValue) {
      return true;
    }
    if (T == BeizeClassValue) {
      return this is BeizeClassValue;
    }
    if (T == BeizeObjectValue) {
      return this is BeizeObjectValue;
    }
    if (T == BeizeCallableValue) {
      return this is BeizeCallableValue;
    }
    final BeizeValueKind to = getKindFromType(T);
    return kind == to;
  }

  bool get isTruthy;
  bool get isFalsey => !isTruthy;
  int get kHashCode;

  @override
  String toString() => 'Beize${kind.code}Value: ${kToString()}';

  static final Map<Type, BeizeValueKind> _typeKindMap = <Type, BeizeValueKind>{
    BeizeBooleanValue: BeizeValueKind.boolean,
    // assume callable value as a function
    BeizeCallableValue: BeizeValueKind.function,
    BeizeClassValue: BeizeValueKind.clazz,
    BeizeExceptionValue: BeizeValueKind.exception,
    BeizeFunctionValue: BeizeValueKind.function,
    BeizeListValue: BeizeValueKind.list,
    BeizeMapValue: BeizeValueKind.map,
    BeizeModuleValue: BeizeValueKind.module,
    BeizeObjectValue: BeizeValueKind.object,
    BeizeNumberValue: BeizeValueKind.number,
    BeizeStringValue: BeizeValueKind.string,
    BeizeUnawaitedValue: BeizeValueKind.unawaited,
    BeizeNullValue: BeizeValueKind.nullValue,
  };

  static BeizeValueKind getKindFromType(final Type type) => _typeKindMap[type]!;
}
