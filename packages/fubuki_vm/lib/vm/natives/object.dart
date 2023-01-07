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
    value.set(
      FubukiStringValue('entries'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue value = call.argumentAt(0);
          return entries(value);
        },
      ),
    );
    value.set(
      FubukiStringValue('keys'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue value = call.argumentAt(0);
          return FubukiListValue(value.keys.values.toList());
        },
      ),
    );
    value.set(
      FubukiStringValue('values'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue value = call.argumentAt(0);
          return FubukiListValue(value.values.values.toList());
        },
      ),
    );
    value.set(
      FubukiStringValue('clone'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      FubukiStringValue('deleteProperty'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiPrimitiveObjectValue value = call.argumentAt(0);
          final FubukiValue key = call.argumentAt(1);
          value.delete(key);
          return FubukiNullValue.value;
        },
      ),
    );
    namespace.declare('Object', value);
  }

  static FubukiListValue entries(final FubukiPrimitiveObjectValue value) {
    final FubukiListValue result = FubukiListValue();
    for (final int x in value.keys.keys) {
      result.push(
        FubukiListValue(<FubukiValue>[
          value.keys[x]!,
          value.values[x]!,
        ]),
      );
    }
    return result;
  }
}
