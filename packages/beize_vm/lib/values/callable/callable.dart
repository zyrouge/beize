import '../../vm/exports.dart';
import '../exports.dart';

abstract class BeizeCallableValue extends BeizeObjectValue {
  BeizeInterpreterResult kCall(final BeizeCallableCall call);
}
