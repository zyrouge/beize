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

  int get length => values.length;

  @override
  final FubukiValueKind kind = FubukiValueKind.list;

  @override
  FubukiListValue kClone() => FubukiListValue(elements.toList());

  @override
  String kToString() =>
      '[${elements.map((final FubukiValue x) => x.kToString()).join(', ')}]';

  @override
  bool get isTruthy => values.isNotEmpty;

  @override
  int get kHashCode => values.hashCode;
}
