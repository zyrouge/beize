import '../errors/exports.dart';

abstract class BeizeValue {
  String get kName;

  String kToString();

  bool kEquals(final BeizeValue other);

  T cast<T extends BeizeValue>() {
    if (canCast<T>()) {
      return this as T;
    }
    throw BeizeRuntimeException.cannotCastTo(kName, T.toString());
  }

  bool canCast<T extends BeizeValue>() => this is T;

  bool get isTruthy;

  bool get isFalsey => !isTruthy;

  int get kHashCode;

  @override
  String toString() => 'Beize${kName}Value: ${kToString()}';
}
