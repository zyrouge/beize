import '../exports.dart';

abstract class BeizeClassValue extends BeizeNativeObjectValue
    implements BeizeCallableValue {
  bool kInstance(final BeizeObjectValue value);

  @override
  BeizeClassValue get kClass => this;
}
