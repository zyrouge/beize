import '../../vm/exports.dart';
import '../exports.dart';

class BeizeListValue extends BeizeNativeObjectValue {
  BeizeListValue([final List<BeizeValue>? elements])
      : elements = elements ?? <BeizeValue>[];

  final List<BeizeValue> elements;

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'push':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              push(call.argumentAt(0));
              return BeizeNullValue.value;
            },
          );

        case 'pushAll':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              pushAll(call.argumentAt(0));
              return BeizeNullValue.value;
            },
          );

        case 'pop':
          return BeizeNativeFunctionValue.sync((final _) => pop());

        case 'clear':
          return BeizeNativeFunctionValue.sync(
            (final _) {
              elements.clear();
              return BeizeNullValue.value;
            },
          );

        case 'length':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeNumberValue(length.toDouble()),
          );

        case 'isEmpty':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(elements.isEmpty),
          );

        case 'isNotEmpty':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeBooleanValue(elements.isNotEmpty),
          );

        case 'clone':
          return BeizeNativeFunctionValue.sync((final _) => kClone());

        case 'reversed':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeListValue(elements.reversed.toList()),
          );

        case 'contains':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeValue value = call.argumentAt(0);
              return BeizeBooleanValue(
                elements.any((final BeizeValue x) => value.kEquals(x)),
              );
            },
          );

        case 'indexOf':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeValue value = call.argumentAt(0);
              return BeizeNumberValue(
                elements
                    .indexWhere((final BeizeValue x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeValue value = call.argumentAt(0);
              return BeizeNumberValue(
                elements
                    .lastIndexWhere((final BeizeValue x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'remove':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeValue value = call.argumentAt(0);
              elements.removeWhere((final BeizeValue x) => value.kEquals(x));
              return BeizeNullValue.value;
            },
          );

        case 'sublist':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeNumberValue start = call.argumentAt(0);
              final BeizeNumberValue end = call.argumentAt(1);
              final int iEnd = end.intValue;
              final List<BeizeValue> sublist = elements.sublist(
                start.intValue,
                iEnd < length ? iEnd : length,
              );
              return BeizeListValue(sublist);
            },
          );

        case 'find':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              for (final BeizeValue x in elements) {
                final BeizeValue result = call.frame
                    .callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) return x;
              }
              return BeizeNullValue.value;
            },
          );

        case 'findIndex':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              for (int i = 0; i < elements.length; i++) {
                final BeizeValue x = elements[i];
                final BeizeValue result = call.frame
                    .callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return BeizeNumberValue(i.toDouble());
                }
              }
              return BeizeNumberValue(-1);
            },
          );

        case 'findLastIndex':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              for (int i = elements.length - 1; i >= 0; i--) {
                final BeizeValue x = elements[i];
                final BeizeValue result = call.frame
                    .callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return BeizeNumberValue(i.toDouble());
                }
              }
              return BeizeNumberValue(-1);
            },
          );

        case 'filter':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              final BeizeListValue nValue = BeizeListValue();
              for (final BeizeValue x in elements) {
                final BeizeValue result = call.frame
                    .callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(x);
                }
              }
              return nValue;
            },
          );

        case 'map':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              final BeizeListValue nValue = BeizeListValue();
              for (final BeizeValue x in elements) {
                final BeizeValue result = call.frame
                    .callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
                nValue.push(result);
              }
              return nValue;
            },
          );

        case 'where':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              final BeizeListValue nValue = BeizeListValue();
              for (final BeizeValue x in elements) {
                final BeizeValue result = call.frame
                    .callValue(predicate, <BeizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(result);
                }
              }
              return nValue;
            },
          );

        case 'sort':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              final List<BeizeValue> sorted = elements.toList();
              for (int i = 0; i < sorted.length; i++) {
                bool swapped = false;
                for (int j = 0; j < sorted.length - i - 1; j++) {
                  final BeizeValue a = sorted[j];
                  final BeizeValue b = sorted[j + 1];
                  final BeizeValue result = call.frame
                      .callValue(predicate, <BeizeValue>[a, b]).unwrapUnsafe();
                  final bool shouldSwap =
                      result.cast<BeizeNumberValue>().value > 0;
                  if (shouldSwap) {
                    sorted[j] = b;
                    sorted[j + 1] = a;
                    swapped = true;
                  }
                }
                if (!swapped) break;
              }
              return BeizeListValue(sorted);
            },
          );

        case 'flat':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeNumberValue level = call.argumentAt(0);
              return BeizeListValue(flat(level.intValue));
            },
          );

        case 'flatDeep':
          return BeizeNativeFunctionValue.sync(
            (final _) => BeizeListValue(flatDeep()),
          );

        case 'unique':
          return BeizeNativeFunctionValue.sync(
            (final _) {
              final BeizeListValue unique = BeizeListValue();
              final List<int> hashes = <int>[];
              for (final BeizeValue x in elements) {
                if (!hashes.contains(x.kHashCode)) {
                  unique.push(x);
                  hashes.add(x.kHashCode);
                }
              }
              return unique;
            },
          );

        case 'forEach':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeCallableValue predicate = call.argumentAt(0);
              for (final BeizeValue x in elements) {
                call.frame.callValue(predicate, <BeizeValue>[x]);
              }
              return BeizeNullValue.value;
            },
          );

        case 'join':
          return BeizeNativeFunctionValue.sync(
            (final BeizeCallableCall call) {
              final BeizeStringValue delimiter = call.argumentAt(0);
              final String delimiterValue = delimiter.value;
              final StringBuffer buffer = StringBuffer();
              final int max = length;
              for (int i = 0; i < max; i++) {
                buffer.write(elements[i].kToString());
                if (i < max - 1) {
                  buffer.write(delimiterValue);
                }
              }
              return BeizeStringValue(buffer.toString());
            },
          );

        default:
      }
    }
    if (key is BeizeNumberValue) return getIndex(key.intValue);
    return super.get(key);
  }

  @override
  void set(final BeizeValue key, final BeizeValue value) {
    if (key is BeizeNumberValue) return setIndex(key.intValue, value);
    super.set(key, value);
  }

  BeizeValue getIndex(final int index) =>
      index < length ? elements[index] : BeizeNullValue.value;

  void setIndex(final int index, final BeizeValue value) {
    if (index > length) {
      elements.addAll(
        List<BeizeNullValue>.filled(
          index - length + 1,
          BeizeNullValue.value,
        ),
      );
    }
    elements[index] = value;
  }

  void push(final BeizeValue value) {
    elements.add(value);
  }

  void pushAll(final BeizeListValue value) {
    elements.addAll(value.elements);
  }

  BeizeValue pop() {
    if (elements.isNotEmpty) {
      return elements.removeLast();
    }
    return BeizeNullValue.value;
  }

  List<BeizeValue> flat(final int level) {
    List<BeizeValue> flat = elements.toList();
    for (int i = 0; i < level; i++) {
      flat = _flatOnce(flat.cast<BeizeListValue>());
    }
    return flat;
  }

  List<BeizeValue> flatDeep() {
    final List<BeizeValue> flat = <BeizeValue>[];
    for (final BeizeValue x in elements) {
      if (x is BeizeListValue) {
        flat.addAll(x.flatDeep());
      } else {
        flat.add(x);
      }
    }
    return flat;
  }

  int get length => elements.length;

  @override
  final BeizeValueKind kind = BeizeValueKind.list;

  @override
  BeizeListValue kClone() => BeizeListValue(elements.toList())..kCopyFrom(this);

  @override
  String kToString() =>
      '[${elements.map((final BeizeValue x) => x.kToString()).join(', ')}]';

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.listClass;

  @override
  bool get isTruthy => elements.isNotEmpty;

  @override
  int get kHashCode => elements.hashCode;
}

List<BeizeValue> _flatOnce(final List<BeizeValue> elements) {
  final List<BeizeValue> flat = <BeizeValue>[];
  for (final BeizeValue x in elements) {
    flat.addAll(x.cast<BeizeListValue>().elements);
  }
  return flat;
}
