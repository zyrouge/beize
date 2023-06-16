import '../../errors/exports.dart';
import '../../values/exports.dart';
import '../namespace.dart';
import 'object.dart';

abstract class BeizeListNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          if (value is BeizeListValue) {
            return value.kClone();
          }
          if (value is BeizePrimitiveObjectValue) {
            final BeizePrimitiveObjectValue obj = call.argumentAt(0);
            return BeizeObjectNatives.entries(obj);
          }
          throw BeizeNativeException(
            'Cannot create list from "${value.kind}"',
          );
        },
      ),
    );
    value.set(
      BeizeStringValue('generate'),
      BeizeNativeFunctionValue.async(
        (final BeizeNativeFunctionCall call) async {
          final int length = call.argumentAt<BeizeNumberValue>(0).intValue;
          final BeizeFunctionValue predicate = call.argumentAt(1);
          final BeizeListValue result = BeizeListValue();
          for (int i = 0; i < length; i++) {
            result.push(
              await call.frame.callValue(
                predicate,
                <BeizeValue>[BeizeNumberValue(i.toDouble())],
              ).unwrapUnsafe(),
            );
          }
          return result;
        },
      ),
    );
    value.set(
      BeizeStringValue('filled'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final int length = call.argumentAt<BeizeNumberValue>(0).intValue;
          final BeizeValue value = call.argumentAt(1);
          final BeizeListValue result =
              BeizeListValue(List<BeizeValue>.filled(length, value));
          return result;
        },
      ),
    );
    namespace.declare('List', value);
  }
}
