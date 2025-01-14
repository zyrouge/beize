import '../errors/exports.dart';

abstract class BeizeValue {
  String get kName;

  String kToString();

  bool kEquals(final BeizeValue other);

  T cast<T extends BeizeValue>() {
    if (!isCastableTo<T>()) {
      throw BeizeRuntimeException.cannotCastTo(
        T.toString(),
        '$runtimeType ($kName)',
      );
    }
    return this as T;
  }

  bool isCastableTo<T extends BeizeValue>() => this is T;

  bool get isTruthy;

  bool get isFalsey => !isTruthy;

  int get kHashCode;

  @override
  String toString() => 'Beize${kName}Value: ${kToString()}';
}
