import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeObjectNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('from'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      BaizeStringValue('fromEntries'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeListValue value = call.argumentAt(0);
          final BaizeObjectValue nValue = BaizeObjectValue();
          for (final int x in value.keys.keys) {
            nValue.set(value.keys[x]!, value.values[x]!);
          }
          return nValue;
        },
      ),
    );
    value.set(
      BaizeStringValue('apply'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizePrimitiveObjectValue a = call.argumentAt(0);
          final BaizePrimitiveObjectValue b = call.argumentAt(1);
          for (final int x in b.keys.keys) {
            a.set(b.keys[x]!, b.values[x]!);
          }
          return a;
        },
      ),
    );
    value.set(
      BaizeStringValue('entries'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizePrimitiveObjectValue value = call.argumentAt(0);
          return entries(value);
        },
      ),
    );
    value.set(
      BaizeStringValue('keys'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizePrimitiveObjectValue value = call.argumentAt(0);
          return BaizeListValue(value.keys.values.toList());
        },
      ),
    );
    value.set(
      BaizeStringValue('values'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizePrimitiveObjectValue value = call.argumentAt(0);
          return BaizeListValue(value.values.values.toList());
        },
      ),
    );
    value.set(
      BaizeStringValue('clone'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizePrimitiveObjectValue value = call.argumentAt(0);
          return value.kClone();
        },
      ),
    );
    value.set(
      BaizeStringValue('deleteProperty'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizePrimitiveObjectValue value = call.argumentAt(0);
          final BaizeValue key = call.argumentAt(1);
          value.delete(key);
          return BaizeNullValue.value;
        },
      ),
    );
    namespace.declare('Object', value);
  }

  static BaizeListValue entries(final BaizePrimitiveObjectValue value) {
    final BaizeListValue result = BaizeListValue();
    for (final int x in value.keys.keys) {
      result.push(
        BaizeListValue(<BaizeValue>[
          value.keys[x]!,
          value.values[x]!,
        ]),
      );
    }
    return result;
  }
}
