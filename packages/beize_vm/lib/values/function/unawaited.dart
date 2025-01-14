import '../../vm/exports.dart';
import '../exports.dart';

typedef BeizeUnawaitedFunction = Future<BeizeInterpreterResult> Function(
  BeizeFunctionCall call,
);

class BeizeUnawaitedValue extends BeizePrimitiveObjectValue {
  BeizeUnawaitedValue(this.arguments, this.function);

  final List<BeizeValue> arguments;
  final BeizeUnawaitedFunction function;

  Future<BeizeInterpreterResult> execute(final BeizeCallFrame frame) async {
    try {
      final BeizeFunctionCall call = BeizeFunctionCall(
        arguments: arguments,
        frame: frame,
      );
      final BeizeInterpreterResult result = await function(call);
      return result;
    } catch (err, stackTrace) {
      return BeizeFunctionValueUtils.handleException(
        frame,
        err,
        stackTrace,
      );
    }
  }

  @override
  final String kName = 'Unawaited';

  @override
  BeizeUnawaitedClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.unawaitedClass;

  @override
  BeizeUnawaitedValue kClone() => BeizeUnawaitedValue(arguments, function);

  @override
  String kToString() => '<unawaited>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
