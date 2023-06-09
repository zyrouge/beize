import '../../errors/native_exception.dart';
import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiNumberNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('infinity'),
      FubukiNumberValue(double.infinity),
    );
    value.set(
      FubukiStringValue('negativeInfinity'),
      FubukiNumberValue(double.negativeInfinity),
    );
    value.set(
      FubukiStringValue('NaN'),
      FubukiNumberValue(double.nan),
    );
    value.set(
      FubukiStringValue('maxFinite'),
      FubukiNumberValue(double.maxFinite),
    );
    value.set(
      FubukiStringValue('from'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return FubukiNumberValue(parsed);
          throw FubukiNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      FubukiStringValue('fromOrNull'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return FubukiNumberValue(parsed);
          return FubukiNullValue.value;
        },
      ),
    );
    value.set(
      FubukiStringValue('fromRadix'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final FubukiNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return FubukiNumberValue(parsed);
          throw FubukiNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    value.set(
      FubukiStringValue('fromRadixOrNull'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final FubukiNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return FubukiNumberValue(parsed);
          return FubukiNullValue.value;
        },
      ),
    );
    namespace.declare('Number', value);
  }
}
