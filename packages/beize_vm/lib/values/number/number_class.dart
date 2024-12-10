import '../../errors/exports.dart';
import '../exports.dart';

class BeizeNumberClassValue extends BeizeNativeClassValue {
  BeizeNumberClassValue() {
    setField('infinity', BeizeNumberValue(double.infinity));
    setField('negativeInfinity', BeizeNumberValue(double.negativeInfinity));
    setField('NaN', BeizeNumberValue(double.nan));
    setField('maxFinite', BeizeNumberValue(double.maxFinite));
    setField(
      'from',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    setField(
      'fromOrNull',
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          return BeizeNullValue.value;
        },
      ),
    );
    setField(
      'fromRadix',
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
    setField(
      'fromRadixOrNull',
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
  bool kInstance(final BeizeObjectValue value) => value is BeizeNumberValue;

  @override
  BeizeNumberValue kInstantiate(final BeizeCallableCall call) {
    final BeizeNumberValue value = call.argumentAt(0);
    return value.kClone();
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
