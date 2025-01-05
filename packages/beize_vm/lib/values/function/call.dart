import '../../errors/exports.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class BeizeFunctionCall {
  BeizeFunctionCall({
    required this.frame,
    required this.arguments,
  });

  final BeizeCallFrame frame;
  final List<BeizeValue> arguments;

  T argumentAt<T extends BeizeValue>(final int index) {
    final BeizeValue value =
        index < arguments.length ? arguments[index] : BeizeNullValue.value;
    if (!value.canCast<T>()) {
      throw BeizeRuntimeException.unexpectedArgumentType(
        index,
        T.toString(),
        value.kName,
      );
    }
    return value as T;
  }

  bool argumentAtIs<T extends BeizeValue>(final int index) {
    final BeizeValue value =
        index < arguments.length ? arguments[index] : BeizeNullValue.value;
    return value.canCast<T>();
  }

  T? argumentAtOrNull<T extends BeizeValue>(final int index) {
    final BeizeValue value =
        index < arguments.length ? arguments[index] : BeizeNullValue.value;
    if (!value.canCast<T>()) {
      return null;
    }
    return value as T;
  }
}
