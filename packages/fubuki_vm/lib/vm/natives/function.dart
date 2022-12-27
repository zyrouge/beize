import '../../values/exports.dart';
import '../namespace.dart';
import '../vm.dart';

abstract class FubukiFunctionNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('call'),
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) async {
          final FubukiValue fn = call.argumentAt(0);
          final FubukiListValue arguments = call.argumentAt(1);
          return fn.callInVM(call.vm, arguments.elements);
        },
      ),
    );
    namespace.declare('Function', value);
  }
}
