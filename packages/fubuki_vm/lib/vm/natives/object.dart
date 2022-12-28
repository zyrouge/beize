import '../../values/exports.dart';
import '../namespace.dart';
import '../vm.dart';

abstract class FubukiObjectNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      FubukiStringValue('fromEntries'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiListValue value = call.argumentAt(0);
          final FubukiObjectValue nValue = FubukiObjectValue();
          for (final int x in value.keys.keys) {
            nValue.set(value.keys[x]!, value.values[x]!);
          }
          return nValue;
        },
      ),
    );
    value.set(
      FubukiStringValue('apply'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue a = call.argumentAt(0);
          final FubukiPrimitiveObjectValue b = call.argumentAt(0);
          for (final int x in b.keys.keys) {
            a.set(b.keys[x]!, b.values[x]!);
          }
          return a;
        },
      ),
    );
    _bindToNativeFunction(
      value,
      'entries',
      FubukiPrimitiveObjectValue.kEntriesProperty,
    );
    _bindToNativeFunction(
      value,
      'keys',
      FubukiPrimitiveObjectValue.kKeysProperty,
    );
    _bindToNativeFunction(
      value,
      'values',
      FubukiPrimitiveObjectValue.kValuesProperty,
    );
    _bindToNativeFunction(
      value,
      'clone',
      FubukiPrimitiveObjectValue.kCloneProperty,
    );
    namespace.declare('Object', value);
  }

  static void _bindToNativeFunction(
    final FubukiObjectValue value,
    final String name,
    final String to,
  ) {
    value.set(
      FubukiStringValue(name),
      FubukiNativeFunctionValue(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue obj = call.argumentAt(0);
          final FubukiValue fn = obj.get(FubukiStringValue(to));
          return fn.callInVM(call.vm, <FubukiValue>[]);
        },
      ),
    );
  }
}
