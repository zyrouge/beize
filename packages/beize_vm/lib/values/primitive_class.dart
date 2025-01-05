import '../vm/exports.dart';
import 'exports.dart';

abstract class BeizePrimitiveClassValue extends BeizePrimitiveObjectValue
    implements BeizeCallableValue {
  BeizePrimitiveClassValue({
    final BeizeObjectValueFieldsMap? instanceFields,
    super.fields,
    super.internals,
  }) : instanceFields = instanceFields ?? BeizeObjectValueFieldsMap.empty();

  final BeizeObjectValueFieldsMap instanceFields;

  BeizeValue? getInstanceFieldOrNull(
    final BeizePrimitiveObjectValue object,
    final BeizeValue key,
  ) {
    final BeizeValue? value = instanceFields.getOrNull(key);
    if (value is BeizeCallableValue) {
      return BeizeBoundFunctionValue(object: object, function: value);
    }
    return value;
  }

  @override
  BeizeClassValue kClass(final BeizeCallFrame frame) => frame.vm.globals.clazz;

  bool kIsInstance(final BeizePrimitiveObjectValue value);

  @override
  BeizePrimitiveClassValue kClone() => this;
}
