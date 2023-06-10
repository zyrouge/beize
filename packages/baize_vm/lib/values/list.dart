import 'exports.dart';

class BaizeListValue extends BaizePrimitiveObjectValue {
  BaizeListValue([final List<BaizeValue>? elements])
      : elements = elements ?? <BaizeValue>[];

  final List<BaizeValue> elements;

  @override
  BaizeValue get(final BaizeValue key) {
    if (key is BaizeStringValue) {
      switch (key.value) {
        case 'push':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              push(call.argumentAt(0));
              return BaizeNullValue.value;
            },
          );

        case 'pushAll':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              pushAll(call.argumentAt(0));
              return BaizeNullValue.value;
            },
          );

        case 'pop':
          return BaizeNativeFunctionValue.sync((final _) => pop());

        case 'clear':
          return BaizeNativeFunctionValue.sync(
            (final _) {
              elements.clear();
              return BaizeNullValue.value;
            },
          );

        case 'length':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(length.toDouble()),
          );

        case 'isEmpty':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(elements.isEmpty),
          );

        case 'isNotEmpty':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(elements.isNotEmpty),
          );

        case 'clone':
          return BaizeNativeFunctionValue.sync((final _) => kClone());

        case 'reversed':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeListValue(elements.reversed.toList()),
          );

        case 'contains':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeValue value = call.argumentAt(0);
              return BaizeBooleanValue(
                elements.any((final BaizeValue x) => value.kEquals(x)),
              );
            },
          );

        case 'indexOf':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeValue value = call.argumentAt(0);
              return BaizeNumberValue(
                elements
                    .indexWhere((final BaizeValue x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeValue value = call.argumentAt(0);
              return BaizeNumberValue(
                elements
                    .lastIndexWhere((final BaizeValue x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'remove':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeValue value = call.argumentAt(0);
              elements.removeWhere((final BaizeValue x) => value.kEquals(x));
              return BaizeNullValue.value;
            },
          );

        case 'sublist':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeNumberValue start = call.argumentAt(0);
              final BaizeNumberValue end = call.argumentAt(1);
              final int iEnd = end.intValue;
              final List<BaizeValue> sublist = elements.sublist(
                start.intValue,
                iEnd < length ? iEnd : length,
              );
              return BaizeListValue(sublist);
            },
          );

        case 'find':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              for (final BaizeValue x in elements) {
                final BaizeValue result = await call.frame
                    .callValue(predicate, <BaizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) return x;
              }
              return BaizeNullValue.value;
            },
          );

        case 'findIndex':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              for (int i = 0; i < elements.length; i++) {
                final BaizeValue x = elements[i];
                final BaizeValue result = await call.frame
                    .callValue(predicate, <BaizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return BaizeNumberValue(i.toDouble());
                }
              }
              return BaizeNumberValue(-1);
            },
          );

        case 'findLastIndex':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              for (int i = elements.length - 1; i >= 0; i--) {
                final BaizeValue x = elements[i];
                final BaizeValue result = await call.frame
                    .callValue(predicate, <BaizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return BaizeNumberValue(i.toDouble());
                }
              }
              return BaizeNumberValue(-1);
            },
          );

        case 'filter':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              final BaizeListValue nValue = BaizeListValue();
              for (final BaizeValue x in elements) {
                final BaizeValue result = await call.frame
                    .callValue(predicate, <BaizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(x);
                }
              }
              return nValue;
            },
          );

        case 'map':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              final BaizeListValue nValue = BaizeListValue();
              for (final BaizeValue x in elements) {
                final BaizeValue result = await call.frame
                    .callValue(predicate, <BaizeValue>[x]).unwrapUnsafe();
                nValue.push(result);
              }
              return nValue;
            },
          );

        case 'where':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              final BaizeListValue nValue = BaizeListValue();
              for (final BaizeValue x in elements) {
                final BaizeValue result = await call.frame
                    .callValue(predicate, <BaizeValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(result);
                }
              }
              return nValue;
            },
          );

        case 'sort':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              final List<BaizeValue> sorted = elements.toList();
              for (int i = 0; i < sorted.length; i++) {
                bool swapped = false;
                for (int j = 0; j < sorted.length - i - 1; j++) {
                  final BaizeValue a = sorted[j];
                  final BaizeValue b = sorted[j + 1];
                  final BaizeValue result = await call.frame
                      .callValue(predicate, <BaizeValue>[a, b]).unwrapUnsafe();
                  final bool shouldSwap =
                      result.cast<BaizeNumberValue>().value > 0;
                  if (shouldSwap) {
                    sorted[j] = b;
                    sorted[j + 1] = a;
                    swapped = true;
                  }
                }
                if (!swapped) break;
              }
              return BaizeListValue(sorted);
            },
          );

        case 'flat':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeNumberValue level = call.argumentAt(0);
              return BaizeListValue(flat(level.intValue));
            },
          );

        case 'flatDeep':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeListValue(flatDeep()),
          );

        case 'unique':
          return BaizeNativeFunctionValue.sync(
            (final _) {
              final BaizeListValue unique = BaizeListValue();
              final List<int> hashes = <int>[];
              for (final BaizeValue x in elements) {
                if (!hashes.contains(x.kHashCode)) {
                  unique.push(x);
                  hashes.add(x.kHashCode);
                }
              }
              return unique;
            },
          );

        case 'forEach':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeFunctionValue predicate = call.argumentAt(0);
              for (final BaizeValue x in elements) {
                await call.frame.callValue(predicate, <BaizeValue>[x]);
              }
              return BaizeNullValue.value;
            },
          );

        case 'join':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeStringValue delimiter = call.argumentAt(0);
              final String delimiterValue = delimiter.value;
              final StringBuffer buffer = StringBuffer();
              final int max = length;
              for (int i = 0; i < max; i++) {
                buffer.write(elements[i].kToString());
                if (max < length - 1) {
                  buffer.write(delimiterValue);
                }
              }
              return BaizeStringValue(buffer.toString());
            },
          );

        default:
      }
    }
    if (key is BaizeNumberValue) return getIndex(key.intValue);
    return super.get(key);
  }

  @override
  void set(final BaizeValue key, final BaizeValue value) {
    if (key is BaizeNumberValue) return setIndex(key.intValue, value);
    super.set(key, value);
  }

  BaizeValue getIndex(final int index) =>
      index < length ? elements[index] : BaizeNullValue.value;

  void setIndex(final int index, final BaizeValue value) {
    if (index > length) {
      elements.addAll(
        List<BaizeNullValue>.filled(
          index - length + 1,
          BaizeNullValue.value,
        ),
      );
    }
    elements[index] = value;
  }

  void push(final BaizeValue value) {
    elements.add(value);
  }

  void pushAll(final BaizeListValue value) {
    elements.addAll(value.elements);
  }

  BaizeValue pop() {
    if (elements.isNotEmpty) {
      return elements.removeLast();
    }
    return BaizeNullValue.value;
  }

  List<BaizeValue> flat(final int level) {
    final List<BaizeValue> flat = <BaizeValue>[];
    for (int i = 0; i < level; i++) {
      for (final BaizeValue x in elements) {
        flat.addAll(x.cast<BaizeListValue>().elements);
      }
    }
    return flat;
  }

  List<BaizeValue> flatDeep() {
    final List<BaizeValue> flat = <BaizeValue>[];
    for (final BaizeValue x in elements) {
      if (x is BaizeListValue) {
        flat.addAll(x.flatDeep());
      } else {
        flat.add(x);
      }
    }
    return flat;
  }

  int get length => elements.length;

  @override
  final BaizeValueKind kind = BaizeValueKind.list;

  @override
  BaizeListValue kClone() => BaizeListValue(elements.toList());

  @override
  String kToString() =>
      '[${elements.map((final BaizeValue x) => x.kToString()).join(', ')}]';

  @override
  bool get isTruthy => elements.isNotEmpty;

  @override
  int get kHashCode => elements.hashCode;
}
