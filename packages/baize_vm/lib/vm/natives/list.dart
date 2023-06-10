import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';
import 'object.dart';

abstract class BaizeListNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('from'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeValue value = call.argumentAt(0);
          if (value is BaizeListValue) {
            return value.kClone();
          }
          if (value is BaizePrimitiveObjectValue) {
            final BaizePrimitiveObjectValue obj = call.argumentAt(0);
            return BaizeObjectNatives.entries(obj);
          }
          throw BaizeNativeException(
            'Cannot create list from "${value.kind}"',
          );
        },
      ),
    );
    value.set(
      BaizeStringValue('generate'),
      BaizeNativeFunctionValue.async(
        (final BaizeNativeFunctionCall call) async {
          final int length = call.argumentAt<BaizeNumberValue>(0).intValue;
          final BaizeFunctionValue predicate = call.argumentAt(1);
          final BaizeListValue result = BaizeListValue();
          for (int i = 0; i < length; i++) {
            result.push(
              await call.frame.callValue(
                predicate,
                <BaizeValue>[BaizeNumberValue(i.toDouble())],
              ).unwrapUnsafe(),
            );
          }
          return result;
        },
      ),
    );
    value.set(
      BaizeStringValue('filled'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final int length = call.argumentAt<BaizeNumberValue>(0).intValue;
          final BaizeValue value = call.argumentAt(1);
          final BaizeListValue result =
              BaizeListValue(List<BaizeValue>.filled(length, value));
          return result;
        },
      ),
    );
    namespace.declare('List', value);
  }
}
