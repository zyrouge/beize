import '../bytecode/exports.dart';
import 'namespace.dart';
import 'vm.dart';

class FubukiCallFrame {
  FubukiCallFrame({
    required this.vm,
    required this.function,
    required this.namespace,
    this.ip = 0,
  });

  int ip;
  final FubukiVM vm;
  final FubukiFunctionConstant function;
  final FubukiNamespace namespace;

  FubukiConstant readConstantAt(final int index) =>
      function.chunk.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine() => 'At ${function.chunk.positionAt(ip)}';
}
