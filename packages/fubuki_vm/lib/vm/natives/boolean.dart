import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiBooleanNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiValue value = call.argumentAt(0);
          return FubukiBooleanValue(value.isTruthy);
        },
      ),
    );
    namespace.declare('Boolean', value);
  }
}
