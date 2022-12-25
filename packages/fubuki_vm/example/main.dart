import 'package:fubuki_vm/exports.dart';

void main() {
  final FubukiChunk chunk = FubukiChunk.empty();
  const String defaultPosition = '0';
  chunk.addOpCode(FubukiOpCodes.opConstant, defaultPosition);
  chunk.addCode(chunk.addConstant(5), defaultPosition);
  chunk.addOpCode(FubukiOpCodes.opConstant, defaultPosition);
  chunk.addCode(chunk.addConstant(2), defaultPosition);
  chunk.addOpCode(FubukiOpCodes.opSubtract, defaultPosition);
  chunk.addOpCode(FubukiOpCodes.opConstant, defaultPosition);
  chunk.addCode(chunk.addConstant(4), defaultPosition);
  chunk.addOpCode(FubukiOpCodes.opDivide, defaultPosition);
  chunk.addOpCode(FubukiOpCodes.opNegate, defaultPosition);
  chunk.addOpCode(FubukiOpCodes.opReturn, defaultPosition);
  // final FubukiInterpreter vm = FubukiInterpreter();
  // vm.interpret(chunk);
}
