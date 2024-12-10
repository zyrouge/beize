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
            (final BeizeNativeFunctionCall call) {
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
  BeizeFunctionValue kClone() =>
      BeizeFunctionValue(constant: constant, namespace: namespace);

  @override
  String kToString() => '<function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
