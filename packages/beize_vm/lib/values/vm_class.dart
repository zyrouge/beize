import '../vm/exports.dart';
import 'exports.dart';

class BeizeVMClassValue extends BeizePrimitiveClassValue {
  BeizeVMClassValue({
    required this.vm,
    super.fields,
    super.instanceFields,
  });

  final BeizeVM vm;

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) => true;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    final BeizeVMObjectValue value = BeizeVMObjectValue(kClass: this);
    final BeizeValue? constructor = getInstanceFieldOrNull(
      value,
      BeizeStringValue(kConstructorFunction),
    );
    if (constructor != null) {
      call.frame.callValue(constructor, <BeizeValue>[]);
    }
    return BeizeInterpreterResult.success(value);
  }

  @override
  String kToString() {
    final BeizeValue? function = getOrNull(BeizeStringValue(kToStringFunction));
    if (function != null) {
      return BeizeCallFrame.kCallValueFrameless(vm, function)
          .unwrapUnsafe()
          .kToString();
    }
    return '<generic class>';
  }

  @override
  String get kName {
    final BeizeValue? function = getOrNull(BeizeStringValue(kNameFunction));
    if (function != null) {
      return BeizeCallFrame.kCallValueFrameless(vm, function)
          .unwrapUnsafe()
          .kToString();
    }
    return 'Class';
  }

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static const String kConstructorFunction = '__constructor__';
  static const String kNameFunction = '__name__';
  static const String kToStringFunction = '__toString__';
}
