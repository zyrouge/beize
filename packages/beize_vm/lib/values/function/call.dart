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
      throw BeizeRuntimeExpection.unexpectedArgumentType(
        index,
        BeizeValue.getKindFromType(T),
        value.kind,
      );
    }
    return value as T;
  }
}
