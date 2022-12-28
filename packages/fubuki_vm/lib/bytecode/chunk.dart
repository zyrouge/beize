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

  factory FubukiChunk.deserialize(final FubukiSerializedConstant serialized) =>
      FubukiChunk(
        codes: (serialized[0] as List<dynamic>).cast<int>(),
        constants: (serialized[1] as List<dynamic>).map((final dynamic x) {
          if (x is List<dynamic>) {
            return FubukiFunctionConstant.deserialize(x);
          }
          return x;
        }).toList(),
        positions: (serialized[2] as List<dynamic>).cast<String>(),
        module: serialized[3] as String,
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
    final int existingIndex = constants.indexOf(value);
    if (existingIndex != -1) return existingIndex;
    constants.add(value);
    return constants.length - 1;
  }

  int codeAt(final int index) => codes[index];

  FubukiOpCodes opCodeAt(final int index) =>
      FubukiOpCodes.values[codeAt(index)];

  FubukiConstant constantAt(final int index) => constants[index];

  String positionAt(final int index) => positions[index];

  FubukiSerializedConstant serialize() {
    final FubukiSerializedConstant serializedConstant =
        constants.map((final FubukiConstant x) {
      if (x is FubukiFunctionConstant) return x.serialize();
      return x;
    }).toList();
    return <dynamic>[codes, serializedConstant, positions, module];
  }

  int get length => codes.length;
}
