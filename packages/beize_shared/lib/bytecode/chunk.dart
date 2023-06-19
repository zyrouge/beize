import 'constants/exports.dart';
import 'op_codes.dart';

class BeizeChunk {
  BeizeChunk({
    required this.moduleId,
    required this.codes,
    required this.constants,
    required this.lines,
  });

  factory BeizeChunk.empty(final int moduleId) => BeizeChunk(
        moduleId: moduleId,
        codes: <int>[],
        constants: <BeizeConstant>[],
        lines: <int>[],
      );

  factory BeizeChunk.deserialize(final BeizeSerializedConstant serialized) =>
      BeizeChunk(
        moduleId: serialized[0] as int,
        codes: (serialized[1] as List<dynamic>).cast<int>(),
        constants: (serialized[2] as List<dynamic>).map((final dynamic x) {
          if (x is List<dynamic>) {
            return BeizeFunctionConstant.deserialize(x);
          }
          return x;
        }).toList(),
        lines: (serialized[3] as List<dynamic>).cast<int>(),
      );

  final int moduleId;
  final List<int> codes;
  final List<BeizeConstant> constants;
  final List<int> lines;

  int addOpCode(final BeizeOpCodes opCode, final int line) =>
      addCode(opCode.index, line);

  int addCode(final int code, final int line) {
    codes.add(code);
    lines.add(line);
    return length - 1;
  }

  int addConstant(final BeizeConstant value) {
    final int existingIndex = constants.indexOf(value);
    if (existingIndex != -1) return existingIndex;
    constants.add(value);
    return constants.length - 1;
  }

  int codeAt(final int index) => codes[index];

  BeizeOpCodes opCodeAt(final int index) => BeizeOpCodes.values[codeAt(index)];

  BeizeConstant constantAt(final int index) => constants[index];

  int lineAt(final int index) => lines[index];

  BeizeSerializedConstant serialize() {
    final BeizeSerializedConstant serializedConstant =
        constants.map((final BeizeConstant x) {
      if (x is BeizeFunctionConstant) return x.serialize();
      return x;
    }).toList();
    return <dynamic>[moduleId, codes, serializedConstant, lines];
  }

  int get length => codes.length;
}
