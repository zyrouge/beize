import '../vm/exports.dart';
import 'exports.dart';

class BeizeListValue extends BeizePrimitiveObjectValue {
  BeizeListValue([final List<BeizeValue>? elements])
      : elements = elements ?? <BeizeValue>[];

  final List<BeizeValue> elements;

  @override
  final String kName = 'List';

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeNumberValue) {
      return getIndex(key.intValue);
    }
    return super.get(key);
  }

  @override
  void set(final BeizeValue key, final BeizeValue value) {
    if (key is BeizeNumberValue) {
      return setIndex(key.intValue, value);
    }
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

  @override
  BeizeListClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.listClass;

  @override
  BeizeListValue kClone() => BeizeListValue(elements.toList());

  @override
  String kToString() {
    final StringBuffer buffer = StringBuffer('[');
    bool hasValues = false;
    for (final BeizeValue x in elements) {
      if (hasValues) {
        buffer.write(', ');
      }
      hasValues = true;
      buffer.write(x.kToString());
    }
    buffer.write(']');
    return buffer.toString();
  }

  int get length => elements.length;

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
