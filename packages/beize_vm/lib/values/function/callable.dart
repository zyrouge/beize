import '../../vm/exports.dart';
import '../exports.dart';

abstract class BeizeCallableValue extends BeizeValue {
  BeizeInterpreterResult kCall(final BeizeFunctionCall call);
}
