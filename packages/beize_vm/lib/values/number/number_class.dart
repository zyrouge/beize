import '../../errors/exports.dart';
import '../exports.dart';

class BeizeNumberClassValue extends BeizeNativeClassValue {
  BeizeNumberClassValue() {
    set(
      BeizeStringValue('infinity'),
      BeizeNumberValue(double.infinity),
    );
    set(
      BeizeStringValue('negativeInfinity'),
      BeizeNumberValue(double.negativeInfinity),
    );
    set(
      BeizeStringValue('NaN'),
      BeizeNumberValue(double.nan),
    );
    set(
      BeizeStringValue('maxFinite'),
      BeizeNumberValue(double.maxFinite),
    );
    set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    set(
      BeizeStringValue('fromOrNull'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          return BeizeNullValue.value;
        },
      ),
    );
    set(
      BeizeStringValue('fromRadix'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final String value = call.argumentAt(0).kToString();
          final BeizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    set(
      BeizeStringValue('fromRadixOrNull'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final String value = call.argumentAt(0).kToString();
          final BeizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BeizeNumberValue(parsed);
          return BeizeNullValue.value;
        },
      ),
    );
  }

  @override
  BeizeNumberValue kInstantiate(final BeizeCallableCall call) {
    final BeizeNumberValue value = call.argumentAt(0);
    return value;
  }

  @override
  BeizeNumberClassValue kClone() => this;

  @override
  String kToString() => '<number class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;
}
