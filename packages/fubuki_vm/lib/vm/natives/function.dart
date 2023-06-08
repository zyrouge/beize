import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiFunctionNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('call'),
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          final FubukiFunctionValue fn = call.argumentAt(0);
          final FubukiListValue arguments = call.argumentAt(1);
          return call.frame.callValue(fn, arguments.elements);
        },
      ),
    );
    namespace.declare('Function', value);
  }
}
