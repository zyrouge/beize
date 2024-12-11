import 'dart:typed_data';
import 'bytecode.dart';
import 'chunk.dart';
import 'constants/constant.dart';
import 'constants/function.dart';
import 'constants/program.dart';

abstract class BeizeConstantSerializer {
  static const String brandMarking = 'github.com/zyrouge/beize';
  static const int doubleMarking = 1;
  static const int stringMarking = 2;
  static const int functionMarking = 3;

  static Uint8List serialize(final BeizeProgramConstant program) {
    final BeizeBytecodeBuilder builder = BeizeBytecodeBuilder();
    builder.addString(brandMarking);
    serializeProgram(builder, program);
    return builder.toBytes();
  }

  static BeizeProgramConstant deserialize(final Uint8List bytes) {
    final BeizeBytecodeReader reader = BeizeBytecodeReader(bytes);
    reader.readString();
    return deserializeProgram(reader);
  }

  static void serializeProgram(
    final BeizeBytecodeBuilder builder,
    final BeizeProgramConstant program,
  ) {
    builder.addInteger(program.version);
    builder.addInteger(program.modules.length);
    for (final int x in program.modules) {
      builder.addInteger(x);
    }
    builder.addInteger(program.constants.length);
    for (final BeizeConstant x in program.constants) {
      serializeConstant(builder, x);
    }
  }

  static BeizeProgramConstant deserializeProgram(
    final BeizeBytecodeReader reader,
  ) {
    final int version = reader.readInteger();
    final List<int> modules = <int>[];
    final int modulesCount = reader.readInteger();
    for (int i = 0; i < modulesCount; i++) {
      modules.add(reader.readInteger());
    }
    final List<BeizeConstant> constants = <BeizeConstant>[];
    final int constantsCount = reader.readInteger();
    for (int i = 0; i < constantsCount; i++) {
      constants.add(deserializeConstant(reader));
    }
    return BeizeProgramConstant(
      version: version,
      modules: modules,
      constants: constants,
    );
  }

  static void serializeConstant(
    final BeizeBytecodeBuilder builder,
    final BeizeConstant constant,
  ) {
    if (constant is BeizeFunctionConstant) {
      serializeFunction(builder, constant);
      return;
    }
    if (constant is double) {
      builder.addByte(doubleMarking);
      builder.addDouble(constant);
      return;
    }
    if (constant is String) {
      builder.addByte(stringMarking);
      builder.addString(constant);
      return;
    }
    throw UnimplementedError('Invalid constant "$constant"');
  }

  static BeizeConstant deserializeConstant(
    final BeizeBytecodeReader reader,
  ) {
    final int marking = reader.readByte();
    switch (marking) {
      case functionMarking:
        return deserializeFunction(reader);

      case doubleMarking:
        return reader.readDouble();

      case stringMarking:
        return reader.readString();
    }
    throw UnimplementedError('Invalid constant marking "$marking"');
  }

  static void serializeFunction(
    final BeizeBytecodeBuilder builder,
    final BeizeFunctionConstant constant,
  ) {
    builder.addByte(functionMarking);
    builder.addInteger(constant.moduleIndex);
    builder.addByte(constant.isAsync ? 1 : 0);
    builder.addInteger(constant.arguments.length);
    for (final int x in constant.arguments) {
      builder.addInteger(x);
    }
    serializeChunk(builder, constant.chunk);
  }

  static BeizeFunctionConstant deserializeFunction(
    final BeizeBytecodeReader reader,
  ) {
    final int moduleIndex = reader.readInteger();
    final bool isAsync = reader.readByte() == 1;
    final List<int> arguments = <int>[];
    final int argumentsCount = reader.readInteger();
    for (int i = 0; i < argumentsCount; i++) {
      arguments.add(reader.readInteger());
    }
    final BeizeChunk chunk = deserializeChunk(reader);
    return BeizeFunctionConstant(
      moduleIndex: moduleIndex,
      isAsync: isAsync,
      arguments: arguments,
      chunk: chunk,
    );
  }

  static void serializeChunk(
    final BeizeBytecodeBuilder builder,
    final BeizeChunk chunk,
  ) {
    builder.addInteger(chunk.codes.length);
    for (final int x in chunk.codes) {
      builder.addInteger(x);
    }
    builder.addInteger(chunk.lines.length);
    for (final int x in chunk.lines) {
      builder.addInteger(x);
    }
  }

  static BeizeChunk deserializeChunk(
    final BeizeBytecodeReader reader,
  ) {
    final List<int> codes = <int>[];
    final int codesCount = reader.readInteger();
    for (int i = 0; i < codesCount; i++) {
      codes.add(reader.readInteger());
    }
    final List<int> lines = <int>[];
    final int linesCount = reader.readInteger();
    for (int i = 0; i < linesCount; i++) {
      lines.add(reader.readInteger());
    }
    return BeizeChunk(codes: codes, lines: lines);
  }
}
