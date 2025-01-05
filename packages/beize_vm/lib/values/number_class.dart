import '../errors/exports.dart';
import '../vm/exports.dart';
import 'exports.dart';

class BeizeNumberClassValue extends BeizePrimitiveClassValue {
  BeizeNumberClassValue() {
    bindClassFields(fields);
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'NumberClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeNumberValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeNumberClassValue value = call.argumentAt(0);
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<number class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('infinity'),
      BeizeNumberValue(double.infinity),
    );
    fields.set(
      BeizeStringValue('negativeInfinity'),
      BeizeNumberValue(double.negativeInfinity),
    );
    fields.set(
      BeizeStringValue('NaN'),
      BeizeNumberValue(double.nan),
    );
    fields.set(
      BeizeStringValue('maxFinite'),
      BeizeNumberValue(double.maxFinite),
    );
    fields.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    fields.set(
      BeizeStringValue('fromOrNull'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final double? parsed = double.tryParse(value);
          if (parsed is double) return BeizeNumberValue(parsed);
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('fromRadix'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final String value = call.argumentAt(0).kToString();
          final BeizeNumberValue radix = call.argumentAt(1);
          final double? parsed =
              int.tryParse(value, radix: radix.intValue)?.toDouble();
          if (parsed is double) return BeizeNumberValue(parsed);
          throw BeizeNativeException('Cannot parse "$value" to number');
        },
      ),
    );
    fields.set(
      BeizeStringValue('fromRadixOrNull'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
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

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('sign'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final _) =>
            BeizeNumberValue(object.value.sign),
      ),
    );
    fields.set(
      BeizeStringValue('isFinite'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.value.isFinite),
      ),
    );
    fields.set(
      BeizeStringValue('isInfinite'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.value.isInfinite),
      ),
    );
    fields.set(
      BeizeStringValue('isNaN'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.value.isNaN),
      ),
    );
    fields.set(
      BeizeStringValue('isNegative'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.value.isNegative),
      ),
    );
    fields.set(
      BeizeStringValue('abs'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final _) =>
            BeizeNumberValue(object.value.abs()),
      ),
    );
    fields.set(
      BeizeStringValue('ceil'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final _) =>
            BeizeNumberValue(object.value.ceilToDouble()),
      ),
    );
    fields.set(
      BeizeStringValue('round'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final _) =>
            BeizeNumberValue(object.value.roundToDouble()),
      ),
    );
    fields.set(
      BeizeStringValue('truncate'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final _) =>
            BeizeNumberValue(object.value.truncateToDouble()),
      ),
    );
    fields.set(
      BeizeStringValue('compareTo'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue other = call.argumentAt(1);
          return BeizeNumberValue(
            object.value.compareTo(other.value).toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('toPrecisionString'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) =>
            BeizeStringValue(
          object.value.toStringAsPrecision(
            call.argumentAt<BeizeNumberValue>(0).intValue,
          ),
        ),
      ),
    );
    fields.set(
      BeizeStringValue('toRadixString'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeNumberValue object, final BeizeFunctionCall call) =>
            BeizeStringValue(
          object.intValue.toRadixString(
            call.argumentAt<BeizeNumberValue>(0).intValue,
          ),
        ),
      ),
    );
  }
}
