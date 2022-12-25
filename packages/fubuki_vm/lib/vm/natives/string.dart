import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiStringNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          return FubukiStringValue(value);
        },
      ),
    );
    namespace.declare('String', value);
  }
}
