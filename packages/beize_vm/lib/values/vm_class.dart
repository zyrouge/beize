import '../vm/exports.dart';
import 'exports.dart';

class BeizeVMClassValue extends BeizePrimitiveClassValue {
  BeizeVMClassValue({
    required this.vm,
    this.parentVMClass,
    super.fields,
    super.instanceFields,
  });

  final BeizeVM vm;
  final BeizeVMClassValue? parentVMClass;

  @override
  BeizeValue? getInstanceFieldOrNull(
    final BeizePrimitiveObjectValue object,
    final BeizeValue key,
  ) =>
      super.getInstanceFieldOrNull(object, key) ??
      parentVMClass?.getInstanceFieldOrNull(object, key);

  @override
  bool kIsInstance(final BeizePrimitiveObjectValue value) =>
      (value is BeizeVMObjectValue && value.kClass_ == this) ||
      (parentVMClass?.kIsInstance(value) ?? false);

  BeizeInterpreterResult _kInstantiate(
    final BeizeFunctionCall call, {
    final bool invokeConstructor = true,
  }) {
    BeizeVMObjectValue? parentVMObject;
    if (parentVMClass != null) {
      final BeizeInterpreterResult result =
          parentVMClass!._kInstantiate(call, invokeConstructor: false);
      if (result.isFailure) {
        return result;
      }
      parentVMObject = result.value as BeizeVMObjectValue;
    }
    final BeizeVMObjectValue value = BeizeVMObjectValue(
      kClass: this,
      parentVMObject: parentVMObject,
    );
    final BeizeValue? constructor = getInstanceFieldOrNull(
      value,
      BeizeStringValue(kConstructorFunction),
    );
    if (invokeConstructor && constructor != null) {
      final BeizeInterpreterResult result =
          call.frame.callValue(constructor, <BeizeValue>[]);
      if (result.isFailure) {
        return result;
      }
    }
    return BeizeInterpreterResult.success(value);
  }

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) =>
      _kInstantiate(call);

  @override
  String kToString() {
    final BeizeValue? function = getOrNull(BeizeStringValue(kToStringFunction));
    if (function != null) {
      return BeizeCallFrame.kCallValueFrameless(vm, function)
          .unwrapUnsafe()
          .kToString();
    }
    final String? name = kNameFromNameFunction();
    if (name != null) {
      return '<class $name>';
    }
    return '<generic class>';
  }

  String? kNameFromNameFunction() {
    final BeizeValue? function = getOrNull(BeizeStringValue(kNameFunction));
    if (function == null) {
      return null;
    }
    return BeizeCallFrame.kCallValueFrameless(vm, function)
        .unwrapUnsafe()
        .kToString();
  }

  @override
  String get kName => kNameFromNameFunction() ?? 'Class';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => hashCode;

  static const String kConstructorFunction = '__constructor__';
  static const String kNameFunction = '__name__';
  static const String kToStringFunction = '__toString__';
}
