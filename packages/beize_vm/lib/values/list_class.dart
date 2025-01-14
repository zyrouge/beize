import '../errors/exports.dart';
import '../vm/exports.dart';
import 'exports.dart';

class BeizeListClassValue extends BeizePrimitiveClassValue {
  BeizeListClassValue() {
    bindClassFields(fields);
    bindInstanceFields(instanceFields);
  }

  @override
  final String kName = 'ListClass';

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      value is BeizeListValue;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeListClassValue value = call.argumentAt(0);
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() => '<list class>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static void bindClassFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('from'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          if (value is BeizeListValue) {
            return value.kClone();
          }
          if (value is BeizePrimitiveObjectValue) {
            final BeizePrimitiveObjectValue obj = call.argumentAt(0);
            return obj.kEntries();
          }
          throw BeizeNativeException(
            'Cannot create list from "${value.kName}"',
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('generate'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final int length = call.argumentAt<BeizeNumberValue>(0).intValue;
          final BeizeCallableValue predicate = call.argumentAt(1);
          final BeizeListValue result = BeizeListValue();
          for (int i = 0; i < length; i++) {
            result.push(
              call.frame.callValue(
                predicate,
                <BeizeValue>[BeizeNumberValue(i.toDouble())],
              ).unwrapUnsafe(),
            );
          }
          return result;
        },
      ),
    );
    fields.set(
      BeizeStringValue('filled'),
      BeizeNativeFunctionValue.sync(
        (final BeizeFunctionCall call) {
          final int length = call.argumentAt<BeizeNumberValue>(0).intValue;
          final BeizeValue value = call.argumentAt(1);
          final BeizeListValue result =
              BeizeListValue(List<BeizeValue>.filled(length, value));
          return result;
        },
      ),
    );
  }

  static void bindInstanceFields(final BeizeObjectValueFieldsMap fields) {
    fields.set(
      BeizeStringValue('push'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          object.push(call.argumentAt(0));
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('pushAll'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          object.pushAll(call.argumentAt(0));
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('pop'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) => object.pop(),
      ),
    );
    fields.set(
      BeizeStringValue('clear'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) {
          object.elements.clear();
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('length'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) =>
            BeizeNumberValue(object.length.toDouble()),
      ),
    );
    fields.set(
      BeizeStringValue('isEmpty'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(call.frame.vm.globals, object.elements.isEmpty),
      ),
    );
    fields.set(
      BeizeStringValue('isNotEmpty'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) =>
            BeizeBooleanValue(
          call.frame.vm.globals,
          object.elements.isNotEmpty,
        ),
      ),
    );
    fields.set(
      BeizeStringValue('clone'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) => object.kClone(),
      ),
    );
    fields.set(
      BeizeStringValue('reversed'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) =>
            BeizeListValue(object.elements.reversed.toList()),
      ),
    );
    fields.set(
      BeizeStringValue('contains'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          return BeizeBooleanValue(
            call.frame.vm.globals,
            object.elements.any((final BeizeValue x) => value.kEquals(x)),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('indexOf'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          return BeizeNumberValue(
            object.elements
                .indexWhere((final BeizeValue x) => value.kEquals(x))
                .toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('lastIndexOf'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          return BeizeNumberValue(
            object.elements
                .lastIndexWhere((final BeizeValue x) => value.kEquals(x))
                .toDouble(),
          );
        },
      ),
    );
    fields.set(
      BeizeStringValue('remove'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeValue value = call.argumentAt(0);
          object.elements.removeWhere((final BeizeValue x) => value.kEquals(x));
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('sublist'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue start = call.argumentAt(0);
          final BeizeNumberValue end = call.argumentAt(1);
          final int iEnd = end.intValue;
          final List<BeizeValue> sublist = object.elements.sublist(
            start.intValue,
            iEnd < object.length ? iEnd : object.length,
          );
          return BeizeListValue(sublist);
        },
      ),
    );
    fields.set(
      BeizeStringValue('find'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          for (final BeizeValue x in object.elements) {
            final BeizeValue result =
                call.frame.callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
            if (result.isTruthy) return x;
          }
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('findIndex'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          for (int i = 0; i < object.elements.length; i++) {
            final BeizeValue x = object.elements[i];
            final BeizeValue result =
                call.frame.callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
            if (result.isTruthy) {
              return BeizeNumberValue(i.toDouble());
            }
          }
          return BeizeNumberValue(-1);
        },
      ),
    );
    fields.set(
      BeizeStringValue('findLastIndex'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          for (int i = object.elements.length - 1; i >= 0; i--) {
            final BeizeValue x = object.elements[i];
            final BeizeValue result =
                call.frame.callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
            if (result.isTruthy) {
              return BeizeNumberValue(i.toDouble());
            }
          }
          return BeizeNumberValue(-1);
        },
      ),
    );
    fields.set(
      BeizeStringValue('filter'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          final BeizeListValue nValue = BeizeListValue();
          for (final BeizeValue x in object.elements) {
            final BeizeValue result =
                call.frame.callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
            if (result.isTruthy) {
              nValue.push(x);
            }
          }
          return nValue;
        },
      ),
    );
    fields.set(
      BeizeStringValue('map'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          final BeizeListValue nValue = BeizeListValue();
          for (final BeizeValue x in object.elements) {
            final BeizeValue result =
                call.frame.callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
            nValue.push(result);
          }
          return nValue;
        },
      ),
    );
    fields.set(
      BeizeStringValue('where'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          final BeizeListValue nValue = BeizeListValue();
          for (final BeizeValue x in object.elements) {
            final BeizeValue result =
                call.frame.callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
            if (result.isTruthy) {
              nValue.push(result);
            }
          }
          return nValue;
        },
      ),
    );
    fields.set(
      BeizeStringValue('sorted'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          final List<BeizeValue> sorted = object.elements.toList();
          sorted.sort((final BeizeValue a, final BeizeValue b) {
            final BeizeNumberValue result = call.frame
                .callValue(predicate, <BeizeValue>[a, b])
                .unwrapUnsafe()
                .cast();
            if (result.value == 0) {
              return 0;
            }
            return result.value < 0 ? -1 : 1;
          });
          return BeizeListValue(sorted);
        },
      ),
    );
    fields.set(
      BeizeStringValue('flat'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeNumberValue level = call.argumentAt(0);
          return BeizeListValue(object.flat(level.intValue));
        },
      ),
    );
    fields.set(
      BeizeStringValue('flatDeep'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) =>
            BeizeListValue(object.flatDeep()),
      ),
    );
    fields.set(
      BeizeStringValue('unique'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final _) {
          final BeizeListValue unique = BeizeListValue();
          final List<int> hashes = <int>[];
          for (final BeizeValue x in object.elements) {
            if (!hashes.contains(x.kHashCode)) {
              unique.push(x);
              hashes.add(x.kHashCode);
            }
          }
          return unique;
        },
      ),
    );
    fields.set(
      BeizeStringValue('forEach'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeCallableValue predicate = call.argumentAt(0);
          for (final BeizeValue x in object.elements) {
            call.frame.callValue(predicate, <BeizeValue>[x]);
          }
          return BeizeNullValue.value;
        },
      ),
    );
    fields.set(
      BeizeStringValue('join'),
      BeizeNativeFunctionValue.boundSync(
        (final BeizeListValue object, final BeizeFunctionCall call) {
          final BeizeStringValue delimiter = call.argumentAt(0);
          final String delimiterValue = delimiter.value;
          final StringBuffer buffer = StringBuffer();
          final int max = object.length;
          for (int i = 0; i < max; i++) {
            buffer.write(object.elements[i].kToString());
            if (i < max - 1) {
              buffer.write(delimiterValue);
            }
          }
          return BeizeStringValue(buffer.toString());
        },
      ),
    );
  }
}
