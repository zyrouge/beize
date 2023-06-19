import '../../errors/exports.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class BeizeNativeFunctionCall {
  BeizeNativeFunctionCall({
    required this.frame,
    required this.arguments,
  });

  final BeizeCallFrame frame;
  final List<BeizeValue> arguments;

  T argumentAt<T extends BeizeValue>(final int index) {
    final BeizeValue value =
        index < arguments.length ? arguments[index] : BeizeNullValue.value;
    if (!value.canCast<T>()) {
      throw BeizeRuntimeExpection(
        'Expected argument at $index to be "${BeizeValue.getKindFromType(T).code}", received "${value.kind.code}"',
      );
    }
    return value as T;
  }
}
