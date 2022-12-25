import '../bytecode/exports.dart';
import '../vm/namespace.dart';
import 'exports.dart';

class FubukiFunctionValue extends FubukiPrimitiveObjectValue {
  FubukiFunctionValue({
    required this.constant,
    required this.namespace,
  });

  final FubukiFunctionConstant constant;
  final FubukiNamespace namespace;

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
