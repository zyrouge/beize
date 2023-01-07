import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiGlobalsNatives {
  static void bind(final FubukiNamespace namespace) {
    namespace.declare(
      'typeof',
      FubukiNativeFunctionValue.sync((final FubukiNativeFunctionCall call) {
        final FubukiValue value = call.argumentAt(0);
        return FubukiStringValue(value.kind.code);
      }),
    );
  }
}
