import 'exports.dart';

class FubukiListValue extends FubukiPrimitiveObjectValue {
  FubukiListValue([final List<FubukiValue>? elements])
      : elements = elements ?? <FubukiValue>[];

  final List<FubukiValue> elements;

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'push':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              push(call.argumentAt(0));
              return FubukiNullValue.value;
            },
          );

        case 'pushAll':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              pushAll(call.argumentAt(0));
              return FubukiNullValue.value;
            },
          );

        case 'pop':
          return FubukiNativeFunctionValue.sync((final _) => pop());

        case 'clear':
          return FubukiNativeFunctionValue.sync(
            (final _) {
              elements.clear();
              return FubukiNullValue.value;
            },
          );

        case 'length':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(length.toDouble()),
          );

        case 'isEmpty':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(elements.isEmpty),
          );

        case 'isNotEmpty':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(elements.isNotEmpty),
          );

        case 'clone':
          return FubukiNativeFunctionValue.sync((final _) => kClone());

        case 'reversed':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiListValue(elements.reversed.toList()),
          );

        case 'contains':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue value = call.argumentAt(0);
              return FubukiBooleanValue(
                elements.any((final FubukiValue x) => value.kEquals(x)),
              );
            },
          );

        case 'indexOf':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue value = call.argumentAt(0);
              return FubukiNumberValue(
                elements
                    .indexWhere((final FubukiValue x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue value = call.argumentAt(0);
              return FubukiNumberValue(
                elements
                    .lastIndexWhere((final FubukiValue x) => value.kEquals(x))
                    .toDouble(),
              );
            },
          );

        case 'remove':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiValue value = call.argumentAt(0);
              elements.removeWhere((final FubukiValue x) => value.kEquals(x));
              return FubukiNullValue.value;
            },
          );

        case 'sublist':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiNumberValue start = call.argumentAt(0);
              final FubukiNumberValue end = call.argumentAt(1);
              final int iEnd = end.intValue;
              final List<FubukiValue> sublist = elements.sublist(
                start.intValue,
                iEnd < length ? iEnd : length,
              );
              return FubukiListValue(sublist);
            },
          );

        case 'find':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              for (final FubukiValue x in elements) {
                final FubukiValue result = await call.frame
                    .callValue(predicate, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) return x;
              }
              return FubukiNullValue.value;
            },
          );

        case 'findIndex':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              for (int i = 0; i < elements.length; i++) {
                final FubukiValue x = elements[i];
                final FubukiValue result = await call.frame
                    .callValue(predicate, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return FubukiNumberValue(i.toDouble());
                }
              }
              return FubukiNumberValue(-1);
            },
          );

        case 'findLastIndex':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              for (int i = elements.length - 1; i >= 0; i--) {
                final FubukiValue x = elements[i];
                final FubukiValue result = await call.frame
                    .callValue(predicate, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return FubukiNumberValue(i.toDouble());
                }
              }
              return FubukiNumberValue(-1);
            },
          );

        case 'filter':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              final FubukiListValue nValue = FubukiListValue();
              for (final FubukiValue x in elements) {
                final FubukiValue result = await call.frame
                    .callValue(predicate, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(x);
                }
              }
              return nValue;
            },
          );

        case 'map':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              final FubukiListValue nValue = FubukiListValue();
              for (final FubukiValue x in elements) {
                final FubukiValue result = await call.frame
                    .callValue(predicate, <FubukiValue>[x]).unwrapUnsafe();
                nValue.push(result);
              }
              return nValue;
            },
          );

        case 'where':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              final FubukiListValue nValue = FubukiListValue();
              for (final FubukiValue x in elements) {
                final FubukiValue result = await call.frame
                    .callValue(predicate, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(result);
                }
              }
              return nValue;
            },
          );

        case 'sort':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              final List<FubukiValue> sorted = elements.toList();
              for (int i = 0; i < sorted.length; i++) {
                bool swapped = false;
                for (int j = 0; j < sorted.length - i - 1; j++) {
                  final FubukiValue a = sorted[j];
                  final FubukiValue b = sorted[j + 1];
                  final FubukiValue result = await call.frame
                      .callValue(predicate, <FubukiValue>[a, b]).unwrapUnsafe();
                  final bool shouldSwap =
                      result.cast<FubukiNumberValue>().value > 0;
                  if (shouldSwap) {
                    sorted[j] = b;
                    sorted[j + 1] = a;
                    swapped = true;
                  }
                }
                if (!swapped) break;
              }
              return FubukiListValue(sorted);
            },
          );

        case 'flat':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiNumberValue level = call.argumentAt(0);
              return FubukiListValue(flat(level.intValue));
            },
          );

        case 'flatDeep':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiListValue(flatDeep()),
          );

        case 'unique':
          return FubukiNativeFunctionValue.sync(
            (final _) {
              final FubukiListValue unique = FubukiListValue();
              final List<int> hashes = <int>[];
              for (final FubukiValue x in elements) {
                if (!hashes.contains(x.kHashCode)) {
                  unique.push(x);
                  hashes.add(x.kHashCode);
                }
              }
              return unique;
            },
          );

        case 'forEach':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiFunctionValue predicate = call.argumentAt(0);
              for (final FubukiValue x in elements) {
                await call.frame.callValue(predicate, <FubukiValue>[x]);
              }
              return FubukiNullValue.value;
            },
          );

        case 'join':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiStringValue delimiter = call.argumentAt(0);
              final String delimiterValue = delimiter.value;
              final StringBuffer buffer = StringBuffer();
              final int max = length;
              for (int i = 0; i < max; i++) {
                buffer.write(elements[i].kToString());
                if (max < length - 1) {
                  buffer.write(delimiterValue);
                }
              }
              return FubukiStringValue(buffer.toString());
            },
          );

        default:
      }
    }
    if (key is FubukiNumberValue) return getIndex(key.intValue);
    return super.get(key);
  }

  @override
  void set(final FubukiValue key, final FubukiValue value) {
    if (key is FubukiNumberValue) return setIndex(key.intValue, value);
    super.set(key, value);
  }

  FubukiValue getIndex(final int index) =>
      index < length ? elements[index] : FubukiNullValue.value;

  void setIndex(final int index, final FubukiValue value) {
    if (index > length) {
      elements.addAll(
        List<FubukiNullValue>.filled(
          index - length + 1,
          FubukiNullValue.value,
        ),
      );
    }
    elements[index] = value;
  }

  void push(final FubukiValue value) {
    elements.add(value);
  }

  void pushAll(final FubukiListValue value) {
    elements.addAll(value.elements);
  }

  FubukiValue pop() {
    if (elements.isNotEmpty) {
      return elements.removeLast();
    }
    return FubukiNullValue.value;
  }

  List<FubukiValue> flat(final int level) {
    final List<FubukiValue> flat = <FubukiValue>[];
    for (int i = 0; i < level; i++) {
      for (final FubukiValue x in elements) {
        flat.addAll(x.cast<FubukiListValue>().elements);
      }
    }
    return flat;
  }

  List<FubukiValue> flatDeep() {
    final List<FubukiValue> flat = <FubukiValue>[];
    for (final FubukiValue x in elements) {
      if (x is FubukiListValue) {
        flat.addAll(x.flatDeep());
      } else {
        flat.add(x);
      }
    }
    return flat;
  }

  int get length => elements.length;

  @override
  final FubukiValueKind kind = FubukiValueKind.list;

  @override
  FubukiListValue kClone() => FubukiListValue(elements.toList());

  @override
  String kToString() =>
      '[${elements.map((final FubukiValue x) => x.kToString()).join(', ')}]';

  @override
  bool get isTruthy => elements.isNotEmpty;

  @override
  int get kHashCode => elements.hashCode;
}
