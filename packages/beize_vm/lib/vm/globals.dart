import '../values/exports.dart';
import 'namespace.dart';

class BeizeGlobals {
  final BeizeBooleanClassValue booleanClass = BeizeBooleanClassValue();
  final BeizeClassClassValue classClass = BeizeClassClassValue();
  final BeizeExceptionClassValue exceptionClass = BeizeExceptionClassValue();
  final BeizeFunctionClassValue functionClass = BeizeFunctionClassValue();
  final BeizeListClassValue listClass = BeizeListClassValue();
  final BeizeMapClassValue mapClass = BeizeMapClassValue();
  final BeizeModuleClassValue moduleClass = BeizeModuleClassValue();
  final BeizeNumberClassValue numberClass = BeizeNumberClassValue();
  final BeizeObjectClassValue objectClass = BeizeObjectClassValue();
  final BeizeStringClassValue stringClass = BeizeStringClassValue();
  final BeizeUnawaitedClassValue unawaitedClass = BeizeUnawaitedClassValue();

  final BeizeBooleanValue trueValue = BeizeBooleanValue(true);
  final BeizeBooleanValue falseValue = BeizeBooleanValue(false);

  void bind(final BeizeNamespace namespace) {
    namespace.declare('Boolean', booleanClass);
    namespace.declare('Class', classClass);
    namespace.declare('Exception', exceptionClass);
    namespace.declare('Function', functionClass);
    namespace.declare('List', listClass);
    namespace.declare('Map', mapClass);
    namespace.declare('Module', moduleClass);
    namespace.declare('Number', numberClass);
    namespace.declare('Object', objectClass);
    namespace.declare('String', stringClass);
    namespace.declare('Unawaited', unawaitedClass);
  }
}
