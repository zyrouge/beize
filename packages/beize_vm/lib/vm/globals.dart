import '../values/exports.dart';
import 'namespace.dart';

class BeizeGlobals {
  final BeizeClassValue clazz = BeizeClassValue();
  final BeizeFunctionClassValue functionClass = BeizeFunctionClassValue();
  final BeizeBooleanClassValue booleanClass = BeizeBooleanClassValue();
  final BeizeExceptionClassValue exceptionClass = BeizeExceptionClassValue();
  final BeizeObjectClassValue objectClass = BeizeObjectClassValue();
  final BeizeListClassValue listClass = BeizeListClassValue();
  final BeizeNumberClassValue numberClass = BeizeNumberClassValue();
  final BeizeStringClassValue stringClass = BeizeStringClassValue();
  final BeizeUnawaitedClassValue unawaitedClass = BeizeUnawaitedClassValue();

  final BeizeBooleanValue trueValue = BeizeBooleanValue.create(true);
  final BeizeBooleanValue falseValue = BeizeBooleanValue.create(false);

  void bind(final BeizeNamespace namespace) {
    namespace.declare('Class', clazz);
    namespace.declare('Function', functionClass);
    namespace.declare('Boolean', booleanClass);
    namespace.declare('Exception', exceptionClass);
    namespace.declare('List', listClass);
    namespace.declare('Number', numberClass);
    namespace.declare('String', stringClass);
    namespace.declare('Unawaited', unawaitedClass);
  }
}
