import '../../bytecode.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class BeizeFunctionValue extends BeizePrimitiveObjectValue
    implements BeizeCallableValue {
  BeizeFunctionValue({
    required this.constant,
    required this.namespace,
  });

  final BeizeFunctionConstant constant;
  final BeizeNamespace namespace;

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'call':
          return BeizeNativeFunctionValue(
            (final BeizeFunctionCall call) {
              final BeizeListValue arguments = call.argumentAt(0);
              return call.frame.callValue(this, arguments.elements);
            },
          );
      }
    }
    return super.get(key);
  }

  bool get isAsync => constant.isAsync;

  @override
  final BeizeValueKind kind = BeizeValueKind.function;

  @override
  BeizeInterpreterResult kCall(final BeizeFunctionCall call) {
    if (!constant.isAsync) {
      final BeizeCallFrame frame =
          call.frame.prepareCallFunctionValue(call.arguments, this);
      return BeizeInterpreter(frame).run();
    }
    final BeizeUnawaitedValue value = BeizeUnawaitedValue(
      call.arguments,
      (final BeizeFunctionCall nCall) async {
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
      BeizeFunctionValue(constant: constant, namespace: namespace);

  @override
  String kToString() => '<function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
