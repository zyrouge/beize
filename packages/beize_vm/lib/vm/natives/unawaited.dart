import '../../values/exports.dart';
import '../exports.dart';

abstract class BeizeUnawaitedNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('value'),
      BeizeNativeFunctionValue.async(
        (final BeizeNativeFunctionCall call) async {
          final BeizeValue value = call.argumentAt(0);
          return value;
        },
      ),
    );
    namespace.declare('Unawaited', value);
  }
}
