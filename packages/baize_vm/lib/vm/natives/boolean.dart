import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeBooleanNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('from'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeValue value = call.argumentAt(0);
          return BaizeBooleanValue(value.isTruthy);
        },
      ),
    );
    namespace.declare('Boolean', value);
  }
}
