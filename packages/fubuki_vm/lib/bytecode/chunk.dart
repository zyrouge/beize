import 'constants/exports.dart';
import 'op_codes.dart';

class FubukiChunk {
  FubukiChunk({
    required this.codes,
    required this.constants,
    required this.positions,
    required this.module,
  });

  factory FubukiChunk.empty(final String module) => FubukiChunk(
        codes: <int>[],
        constants: <FubukiConstant>[],
        positions: <String>[],
        module: module,
      );

  final List<int> codes;
  final List<FubukiConstant> constants;
  final List<String> positions;
  final String module;

  int addOpCode(final FubukiOpCodes opCode, final String position) =>
      addCode(opCode.index, position);

  int addCode(final int code, final String position) {
    codes.add(code);
    positions.add(position);
    return length - 1;
  }

  int addConstant(final FubukiConstant value) {
    constants.add(value);
    return constants.length - 1;
  }

  int codeAt(final int index) => codes[index];

  FubukiOpCodes opCodeAt(final int index) =>
      FubukiOpCodes.values[codeAt(index)];

  FubukiConstant constantAt(final int index) => constants[index];

  String positionAt(final int index) => positions[index];

  int get length => codes.length;
}
