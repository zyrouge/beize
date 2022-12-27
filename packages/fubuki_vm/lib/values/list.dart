import '../vm/exports.dart';
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
              final FubukiNumberValue end = call.argumentAt(0);
              elements.sublist(start.intValue, end.intValue);
              return FubukiNullValue.value;
            },
          );

        case 'find':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiValue predicate = call.argumentAt(0);
              for (final FubukiValue x in elements) {
                final FubukiValue result = await predicate
                    .callInVM(call.vm, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) return x;
              }
              return FubukiNullValue.value;
            },
          );

        case 'findIndex':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiValue predicate = call.argumentAt(0);
              for (int i = 0; i < elements.length; i++) {
                final FubukiValue x = elements[i];
                final FubukiValue result = await predicate
                    .callInVM(call.vm, <FubukiValue>[x]).unwrapUnsafe();
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
              final FubukiValue predicate = call.argumentAt(0);
              for (int i = elements.length - 1; i >= 0; i--) {
                final FubukiValue x = elements[i];
                final FubukiValue result = await predicate
                    .callInVM(call.vm, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  return FubukiNumberValue(i.toDouble());
                }
              }
              return FubukiNumberValue(-1);
            },
          );

        case 'map':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiValue predicate = call.argumentAt(0);
              final FubukiListValue nValue = FubukiListValue();
              for (final FubukiValue x in elements) {
                final FubukiValue result = await predicate
                    .callInVM(call.vm, <FubukiValue>[x]).unwrapUnsafe();
                nValue.push(result);
              }
              return nValue;
            },
          );

        case 'where':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiValue predicate = call.argumentAt(0);
              final FubukiListValue nValue = FubukiListValue();
              for (final FubukiValue x in elements) {
                final FubukiValue result = await predicate
                    .callInVM(call.vm, <FubukiValue>[x]).unwrapUnsafe();
                if (result.isTruthy) {
                  nValue.push(result);
                }
              }
              return nValue;
            },
          );

        // TODO: finish this
        // case 'sort':
        //   return FubukiNativeFunctionValue.async(
        //     (
        //       final FubukiNativeFunctionCall call
        //     ) {
        //       final FubukiValue predicate = call.argumentAt(0);
        //       final List<FubukiValue> sorted = elements.toList();
        //       sorted.sort(
        //         (final FubukiValue a, final FubukiValue b) => predicate
        //             .callInVM(call.vm, <FubukiValue>[a, b])
        //             .cast<FubukiNumberValue>()
        //             .intValue,
        //       );
        //       return FubukiListValue(sorted);
        //     },
        //   );

        case 'forEach':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiValue predicate = call.argumentAt(0);
              for (final FubukiValue x in elements) {
                await predicate.callInVM(call.vm, <FubukiValue>[x]);
              }
              return FubukiNullValue.value;
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

  FubukiValue pop() {
    if (elements.isNotEmpty) {
      return elements.removeLast();
    }
    return FubukiNullValue.value;
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
