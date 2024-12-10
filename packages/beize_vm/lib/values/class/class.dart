import '../../vm/exports.dart';
import '../exports.dart';

abstract class BeizeClassValue extends BeizeNativeObjectValue
    implements BeizeCallableValue {
  bool kInstance(final BeizeObjectValue value);

  BeizeObjectValue kInstantiate(final BeizeCallableCall call);

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) {
    final BeizeObjectValue value = kInstantiate(call);
    return BeizeInterpreterResult.success(value);
  }

  @override
  BeizeClassValue get kClass => this;
}
