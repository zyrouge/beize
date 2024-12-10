import '../../vm/exports.dart';
import '../exports.dart';

class BeizeClassValueUtils {
  static BeizeClassValue getClass(
    final BeizeVM vm,
    final BeizeObjectValue value,
  ) =>
      value.kClassInternal(vm) ?? value.kClass;

  static bool isClassInstance(
    final BeizeValue clazz,
    final BeizeValue value,
  ) =>
      clazz is BeizeClassValue &&
      value is BeizeObjectValue &&
      clazz.kInstance(value);
}
