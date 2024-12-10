import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeBooleanNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          return BeizeBooleanValue(value.isTruthy);
        },
      ),
    );
    namespace.declare('Boolean', value);
  }
}
