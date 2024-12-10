import '../../errors/native_exception.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeNumberNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('infinity'),
      BeizeNumberValue(double.infinity),
    );
    value.set(
      BeizeStringValue('negativeInfinity'),
      BeizeNumberValue(double.negativeInfinity),
    );
    value.set(
      BeizeStringValue('NaN'),
      BeizeNumberValue(double.nan),
    );
    value.set(
      BeizeStringValue('maxFinite'),
      BeizeNumberValue(double.maxFinite),
    );
    value.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      BeizeStringValue('fromOrNull'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          return BeizeNullValue.value;
        },
      ),
    );
    value.set(
      BeizeStringValue('fromRadix'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final BeizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      BeizeStringValue('fromRadixOrNull'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final BeizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BeizeNumberValue(parsed);
          return BeizeNullValue.value;
        },
      ),
    );
    namespace.declare('Number', value);
  }
}
