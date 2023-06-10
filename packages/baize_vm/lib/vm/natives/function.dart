import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeFunctionNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('call'),
      BaizeNativeFunctionValue(
        (final BaizeNativeFunctionCall call) async {
          final BaizeFunctionValue fn = call.argumentAt(0);
          final BaizeListValue arguments = call.argumentAt(1);
          return call.frame.callValue(fn, arguments.elements);
        },
      ),
    );
    namespace.declare('Function', value);
  }
}
