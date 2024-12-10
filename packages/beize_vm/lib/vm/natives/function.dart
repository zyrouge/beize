import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeFunctionNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('call'),
      BeizeNativeFunctionValue(
        (final BeizeNativeFunctionCall call) {
          final BeizeCallableValue fn = call.argumentAt(0);
          final BeizeListValue arguments = call.argumentAt(1);
          return call.frame.callValue(fn, arguments.elements);
        },
      ),
    );
    namespace.declare('Function', value);
  }
}
