import 'dart:typed_data';

class BeizeBytecodeBuilder {
  final BytesBuilder bytesBuilder = BytesBuilder();

  final ByteData _intBytes = ByteData(4);
  final ByteData _doubleBytes = ByteData(8);

  void addByte(final int value) {
    bytesBuilder.addByte(value);
  }

  void addInteger(final int value) {
    _intBytes.setInt32(0, value);
    bytesBuilder.add(_intBytes.buffer.asUint8List());
  }

  void addDouble(final double value) {
    _doubleBytes.setFloat64(0, value);
    bytesBuilder.add(_doubleBytes.buffer.asUint8List());
  }

  void addString(final String value) {
    addInteger(value.codeUnits.length);
    bytesBuilder.add(value.codeUnits);
  }

  Uint8List toBytes() => bytesBuilder.toBytes();
}

class BeizeBytecodeReader {
  BeizeBytecodeReader(this.bytes) : byteData = ByteData.sublistView(bytes);

  final Uint8List bytes;
  final ByteData byteData;

  int index = 0;

  int readByte() {
    final int value = bytes[index];
    index++;
    return value;
  }

  int readInteger() {
    final int value = byteData.getInt32(index);
    index += 4;
    return value;
  }

  double readDouble() {
    final double value = byteData.getFloat64(index);
    index += 8;
    return value;
  }

  String readString() {
    final int length = readInteger();
    final String value =
        String.fromCharCodes(bytes.sublist(index, index + length));
    index += length;
    return value;
  }
}
