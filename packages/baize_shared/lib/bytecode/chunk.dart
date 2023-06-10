import 'constants/exports.dart';
import 'op_codes.dart';

class BaizeChunk {
  BaizeChunk({
    required this.codes,
    required this.constants,
    required this.lines,
    required this.module,
  });

  factory BaizeChunk.empty(final String module) => BaizeChunk(
        codes: <int>[],
        constants: <BaizeConstant>[],
        lines: <int>[],
        module: module,
      );

  factory BaizeChunk.deserialize(final BaizeSerializedConstant serialized) =>
      BaizeChunk(
        codes: (serialized[0] as List<dynamic>).cast<int>(),
        constants: (serialized[1] as List<dynamic>).map((final dynamic x) {
          if (x is List<dynamic>) {
            return BaizeFunctionConstant.deserialize(x);
          }
          return x;
        }).toList(),
        lines: (serialized[2] as List<dynamic>).cast<int>(),
        module: serialized[3] as String,
      );

  final List<int> codes;
  final List<BaizeConstant> constants;
  final List<int> lines;
  final String module;

  int addOpCode(final BaizeOpCodes opCode, final int line) =>
      addCode(opCode.index, line);

  int addCode(final int code, final int line) {
    codes.add(code);
    lines.add(line);
    return length - 1;
  }

  int addConstant(final BaizeConstant value) {
    final int existingIndex = constants.indexOf(value);
    if (existingIndex != -1) return existingIndex;
    constants.add(value);
    return constants.length - 1;
  }

  int codeAt(final int index) => codes[index];

  BaizeOpCodes opCodeAt(final int index) =>
      BaizeOpCodes.values[codeAt(index)];

  BaizeConstant constantAt(final int index) => constants[index];

  int lineAt(final int index) => lines[index];

  BaizeSerializedConstant serialize() {
    final BaizeSerializedConstant serializedConstant =
        constants.map((final BaizeConstant x) {
      if (x is BaizeFunctionConstant) return x.serialize();
      return x;
    }).toList();
    return <dynamic>[codes, serializedConstant, lines, module];
  }

  int get length => codes.length;
}
