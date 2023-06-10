import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeGlobalsNatives {
  static void bind(final BaizeNamespace namespace) {
    namespace.declare(
      'typeof',
      BaizeNativeFunctionValue.sync((final BaizeNativeFunctionCall call) {
        final BaizeValue value = call.argumentAt(0);
        return BaizeStringValue(value.kind.code);
      }),
    );
  }
}
