import '../bytecode.dart';
import '../vm/exports.dart';
import 'exports.dart';

class BaizeFunctionValue extends BaizePrimitiveObjectValue {
  BaizeFunctionValue({
    required this.constant,
    required this.namespace,
  });

  final BaizeFunctionConstant constant;
  final BaizeNamespace namespace;

  @override
  BaizeValue get(final BaizeValue key) {
    if (key is BaizeStringValue) {
      switch (key.value) {
        case 'call':
          return BaizeNativeFunctionValue(
            (final BaizeNativeFunctionCall call) {
              final BaizeListValue arguments = call.argumentAt(0);
              return call.frame.callValue(this, arguments.elements);
            },
          );
      }
    }
    return super.get(key);
  }

  @override
  final BaizeValueKind kind = BaizeValueKind.function;

  @override
  BaizeFunctionValue kClone() =>
      BaizeFunctionValue(constant: constant, namespace: namespace);

  @override
  String kToString() => '<function>';

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => constant.hashCode;
}
