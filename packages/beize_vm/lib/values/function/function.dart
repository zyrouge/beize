import '../../bytecode.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class BeizeFunctionValue extends BeizeNativeObjectValue
    implements BeizeCallableValue {
  BeizeFunctionValue({
    required this.constant,
    required this.namespace,
  });

  final BeizeFunctionConstant constant;
  final BeizeNamespace namespace;

  bool get isAsync => constant.isAsync;

  @override
  final BeizeValueKind kind = BeizeValueKind.function;

  @override
  BeizeInterpreterResult kCall(final BeizeCallableCall call) {
    if (!constant.isAsync) {
      final BeizeCallFrame frame =
          call.frame.prepareCallFunctionValue(call.arguments, this);
      return BeizeInterpreter(frame).run();
    }
    final BeizeUnawaitedValue value = BeizeUnawaitedValue(
      call.arguments,
      (final BeizeCallableCall nCall) async {
        final BeizeCallFrame frame =
            nCall.frame.prepareCallFunctionValue(nCall.arguments, this);
        final BeizeInterpreterResult result =
            await BeizeInterpreter(frame).runAsync();
        return result;
      },
    );
    return BeizeInterpreterResult.success(value);
  }

  @override
  BeizeFunctionValue kClone() =>
      BeizeFunctionValue(constant: constant, namespace: namespace)
        ..kCopyFrom(this);

  @override
  String kToString() => '<function>';

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.functionClass;

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
