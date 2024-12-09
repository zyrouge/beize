import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeGlobalsNatives {
  static void bind(final BeizeNamespace namespace) {
    namespace.declare(
      'typeof',
      BeizeNativeFunctionValue.sync((final BeizeCallableCall call) {
        final BeizeValue value = call.argumentAt(0);
        return BeizeStringValue(value.kind.code);
      }),
    );
  }
}
