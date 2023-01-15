import '../bytecode.dart';
import '../vm/namespace.dart';
import '../vm/vm.dart';
import 'exports.dart';

class FubukiFunctionValue extends FubukiPrimitiveObjectValue {
  FubukiFunctionValue({
    required this.constant,
    required this.namespace,
  });

  final FubukiFunctionConstant constant;
  final FubukiNamespace namespace;

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'call':
          return FubukiNativeFunctionValue(
            (final FubukiNativeFunctionCall call) {
              final FubukiListValue arguments = call.argumentAt(0);
              return callInVM(call.vm, arguments.elements);
            },
          );
      }
    }
    return super.get(key);
  }

  @override
  final FubukiValueKind kind = FubukiValueKind.function;

  @override
  FubukiFunctionValue kClone() =>
      FubukiFunctionValue(constant: constant, namespace: namespace);

  @override
  String kToString() => '<function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
