import '../../vm/exports.dart';
import '../exports.dart';

abstract class BeizeVMObjectValue extends BeizeNativeObjectValue {
  BeizeVMObjectValue({
    super.fields,
    super.internals,
  });

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.objectClass;
}
