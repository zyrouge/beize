import '../../vm/exports.dart';
import '../exports.dart';

typedef BeizeUnawaitedFunction = Future<BeizeInterpreterResult> Function(
  BeizeCallableCall call,
);

class BeizeUnawaitedValue extends BeizeNativeObjectValue {
  BeizeUnawaitedValue(this.arguments, this.function);

  final List<BeizeValue> arguments;
  final BeizeUnawaitedFunction function;

  @override
  final BeizeValueKind kind = BeizeValueKind.unawaited;

  Future<BeizeInterpreterResult> kExecute(final BeizeCallFrame frame) async {
    try {
      final BeizeCallableCall call = BeizeCallableCall(
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
  BeizeUnawaitedValue kClone() => BeizeUnawaitedValue(arguments, function);

  @override
  String kToString() => '<unawaited>';

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.unawaitedClass;

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => function.hashCode;
}
