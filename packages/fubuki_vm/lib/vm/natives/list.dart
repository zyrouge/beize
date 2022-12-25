import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../interpreter.dart';
import '../namespace.dart';
import '../vm.dart';

abstract class FubukiListNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue(
        (
          final FubukiNativeFunctionCall call,
          final FubukiInterpreterCompleter completer,
        ) {
          final FubukiValue value = call.argumentAt(0);
          if (value is FubukiListValue) {
            return completer.complete(value.kClone());
          }
          if (value is FubukiPrimitiveObjectValue) {
            final FubukiPrimitiveObjectValue obj = call.argumentAt(0);
            final FubukiValue fn = obj.get(
              FubukiStringValue(FubukiPrimitiveObjectValue.kEntriesProperty),
            );
            return fn.callInVM(call.vm, <FubukiValue>[], completer);
          }
          throw FubukiNativeException(
            'Cannot create list from "${value.kind}"',
          );
        },
      ),
    );
    namespace.declare('List', value);
  }
}
