import '../../errors/native_exception.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeNumberNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('infinity'),
      BaizeNumberValue(double.infinity),
    );
    value.set(
      BaizeStringValue('negativeInfinity'),
      BaizeNumberValue(double.negativeInfinity),
    );
    value.set(
      BaizeStringValue('NaN'),
      BaizeNumberValue(double.nan),
    );
    value.set(
      BaizeStringValue('maxFinite'),
      BaizeNumberValue(double.maxFinite),
    );
    value.set(
      BaizeStringValue('from'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BaizeNumberValue(parsed);
          throw BaizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      BaizeStringValue('fromOrNull'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BaizeNumberValue(parsed);
          return BaizeNullValue.value;
        },
      ),
    );
    value.set(
      BaizeStringValue('fromRadix'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final BaizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BaizeNumberValue(parsed);
          throw BaizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      BaizeStringValue('fromRadixOrNull'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final BaizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BaizeNumberValue(parsed);
          return BaizeNullValue.value;
        },
      ),
    );
    namespace.declare('Number', value);
  }
}
