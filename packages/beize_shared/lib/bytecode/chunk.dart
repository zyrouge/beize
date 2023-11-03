import 'constants/exports.dart';
import 'op_codes.dart';

class BeizeChunk {
  const BeizeChunk({
    required this.moduleIndex,
    required this.codes,
    required this.lines,
  });

  factory BeizeChunk.empty(final int moduleIndex) =>
      BeizeChunk(moduleIndex: moduleIndex, codes: <int>[], lines: <int>[]);

  factory BeizeChunk.deserialize(final BeizeSerializedConstant serialized) =>
      BeizeChunk(
        moduleIndex: serialized[0] as int,
        codes: (serialized[1] as List<dynamic>).cast<int>(),
        lines: (serialized[2] as List<dynamic>).cast<int>(),
      );

  final int moduleIndex;
  final List<int> codes;
  final List<int> lines;

  int addOpCode(final BeizeOpCodes opCode, final int line) =>
      addCode(opCode.index, line);

  int addCode(final int code, final int line) {
    codes.add(code);
    lines.add(line);
    return length - 1;
  }

  int codeAt(final int index) => codes[index];

  BeizeOpCodes opCodeAt(final int index) => BeizeOpCodes.values[codeAt(index)];

  int lineAt(final int index) => lines[index];

  BeizeSerializedConstant serialize() => <dynamic>[moduleIndex, codes, lines];

  int get length => codes.length;
}
