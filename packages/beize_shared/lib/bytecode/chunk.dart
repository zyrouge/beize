import 'constants/exports.dart';
import 'op_codes.dart';

class BeizeChunk {
  BeizeChunk({
    required this.codes,
    required this.lines,
  });

  factory BeizeChunk.empty() => BeizeChunk(codes: <int>[], lines: <int>[]);

  factory BeizeChunk.deserialize(final BeizeSerializedConstant serialized) =>
      BeizeChunk(
        codes: (serialized[0] as List<dynamic>).cast<int>(),
        lines: (serialized[1] as List<dynamic>).cast<int>(),
      );

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

  BeizeSerializedConstant serialize() => <dynamic>[codes, lines];

  int get length => codes.length;
}
