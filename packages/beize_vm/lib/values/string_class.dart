import '../vm/exports.dart';
import 'exports.dart';

class BeizeStringClassValue extends BeizePrimitiveClassValue {
  BeizeStringClassValue() {
    bindClassFields(fields);
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'StringClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeStringValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizePrimitiveObjectValue value = call.argumentAt(0);
    if (value is BeizeStringValue) {
      return BeizeInterpreterResult.success(value.kClone());
    }
    return BeizeInterpreterResult.success(BeizeStringValue(value.kToString()));
  }

  @override
  String kToString() => '<string class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('fromCodeUnit'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeNumberValue value = call.argumentAt(0);
          return BeizeStringValue(String.fromCharCode(value.intValue));
        },
      ),
    );
    fields.set(
      BeizeStringValue('fromCodeUnits'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeListValue value = call.argumentAt(0);
          return BeizeStringValue(
            String.fromCharCodes(
              value.elements.map(
                (final BeizeValue x) => x.cast<BeizeNumberValue>().intValue,
              ),
            ),
          );
        },
      ),
    );
  }

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('isEmpty'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.value.isEmpty),
      ),
    );
    fields.set(
      BeizeStringValue('isNotEmpty'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.value.isNotEmpty),
      ),
    );
    fields.set(
      BeizeStringValue('length'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) =>
            BeizeNumberValue(object.value.length.toDouble()),
      ),
    );
    fields.set(
      BeizeStringValue('compareTo'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue other = call.argumentAt(0);
          return BeizeNumberValue(
            object.value.compareTo(other.value).toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('contains'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue other = call.argumentAt(0);
          return BeizeBooleanValue(
            call.frame.vm.globals,
            object.value.contains(other.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('startsWith'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue other = call.argumentAt(0);
          return BeizeBooleanValue(
            call.frame.vm.globals,
            object.value.startsWith(other.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('endsWith'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue other = call.argumentAt(0);
          return BeizeBooleanValue(
            call.frame.vm.globals,
            object.value.endsWith(other.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('indexOf'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue other = call.argumentAt(0);
          return BeizeNumberValue(
            object.value.indexOf(other.value).toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('lastIndexOf'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue other = call.argumentAt(0);
          return BeizeNumberValue(
            object.value.lastIndexOf(other.value).toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('substring'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue start = call.argumentAt(0);
          final BeizeNumberValue end = call.argumentAt(1);
          return BeizeStringValue(
            object.value.substring(start.intValue, end.intValue),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceFirst'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue from = call.argumentAt(0);
          final BeizeStringValue to = call.argumentAt(1);
          return BeizeStringValue(
            object.value.replaceFirst(from.value, to.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceAll'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue from = call.argumentAt(0);
          final BeizeStringValue to = call.argumentAt(1);
          return BeizeStringValue(
            object.value.replaceAll(from.value, to.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceFirstMapped'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue result = object.replaceMapped(call, 1);
          return result;
        },
      ),
    );
    fields.set(
      BeizeStringValue('replaceAllMapped'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue result = object.replaceMapped(call);
          return result;
        },
      ),
    );
    fields.set(
      BeizeStringValue('trim'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) =>
            BeizeStringValue(object.value.trim()),
      ),
    );
    fields.set(
      BeizeStringValue('trimLeft'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) =>
            BeizeStringValue(object.value.trimLeft()),
      ),
    );
    fields.set(
      BeizeStringValue('trimRight'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) =>
            BeizeStringValue(object.value.trimRight()),
      ),
    );
    fields.set(
      BeizeStringValue('padLeft'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue amount = call.argumentAt(0);
          final BeizeStringValue by = call.argumentAt(1);
          return BeizeStringValue(
            object.value.padLeft(amount.intValue, by.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('padRight'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue amount = call.argumentAt(0);
          final BeizeStringValue by = call.argumentAt(1);
          return BeizeStringValue(
            object.value.padRight(amount.intValue, by.value),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('split'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeStringValue delimiter = call.argumentAt(0);
          return BeizeListValue(
            object.value
                .split(delimiter.value)
                .map((final String x) => BeizeStringValue(x))
                .toList(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('codeUnitAt'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue index = call.argumentAt(0);
          return BeizeNumberValue(
            object.value.codeUnitAt(index.intValue).toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('charAt'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue index = call.argumentAt(0);
          return BeizeStringValue(object.value[index.intValue]);
        },
      ),
    );
    fields.set(
      BeizeStringValue('toCodeUnits'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) => BeizeListValue(
          object.value.codeUnits
              .map((final int x) => BeizeNumberValue(x.toDouble()))
              .toList(),
        ),
      ),
    );
    fields.set(
      BeizeStringValue('toLowerCase'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) =>
            BeizeStringValue(object.value.toLowerCase()),
      ),
    );
    fields.set(
      BeizeStringValue('toUpperCase'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final _) =>
            BeizeStringValue(object.value.toUpperCase()),
      ),
    );
    fields.set(
      BeizeStringValue('format'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeStringValue object, final BeizeFunctionCall call) {
          final BeizePrimitiveObjectValue value = call.argumentAt(0);
          return BeizeStringValue(object.format(value));
        },
      ),
    );
  }
}
