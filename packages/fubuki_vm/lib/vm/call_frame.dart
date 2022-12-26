import '../bytecode/exports.dart';
import 'namespace.dart';
import 'try_frame.dart';
import 'vm.dart';

class FubukiCallFrame {
  FubukiCallFrame({
    required this.vm,
    required this.function,
    required this.namespace,
  });

  int ip = 0;
  int scopeDepth = 0;
  final List<FubukiTryFrame> tryFrames = <FubukiTryFrame>[];

  final FubukiVM vm;
  final FubukiFunctionConstant function;
  final FubukiNamespace namespace;

  FubukiConstant readConstantAt(final int index) =>
      function.chunk.constantAt(function.chunk.codeAt(index));

  String toStackTraceLine() =>
      '${function.chunk.module} (${function.chunk.positionAt(ip)})';
}
