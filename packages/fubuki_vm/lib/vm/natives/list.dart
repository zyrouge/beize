import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';
import 'object.dart';

abstract class FubukiListNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiValue value = call.argumentAt(0);
          if (value is FubukiListValue) {
            return value.kClone();
          }
          if (value is FubukiPrimitiveObjectValue) {
            final FubukiPrimitiveObjectValue obj = call.argumentAt(0);
            return FubukiObjectNatives.entries(obj);
          }
          throw FubukiNativeException(
            'Cannot create list from "${value.kind}"',
          );
        },
      ),
    );
    value.set(
      FubukiStringValue('generate'),
      FubukiNativeFunctionValue.async(
        (final FubukiNativeFunctionCall call) async {
          final int length = call.argumentAt<FubukiNumberValue>(0).intValue;
          final FubukiFunctionValue predicate = call.argumentAt(1);
          final FubukiListValue result = FubukiListValue();
          for (int i = 0; i < length; i++) {
            result.push(
              await call.frame.callValue(
                predicate,
                <FubukiValue>[FubukiNumberValue(i.toDouble())],
              ).unwrapUnsafe(),
            );
          }
          return result;
        },
      ),
    );
    value.set(
      FubukiStringValue('filled'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final int length = call.argumentAt<FubukiNumberValue>(0).intValue;
          final FubukiValue value = call.argumentAt(1);
          final FubukiListValue result =
              FubukiListValue(List<FubukiValue>.filled(length, value));
          return result;
        },
      ),
    );
    namespace.declare('List', value);
  }
}
