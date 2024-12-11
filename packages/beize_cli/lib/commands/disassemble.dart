import 'dart:io';
import 'dart:typed_data';
import 'package:args/command_runner.dart';
import 'package:beize_compiler/beize_compiler.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import '../utils.dart';

class DisassembleCommand extends Command<Future<void>> {
  @override
  final String name = 'disassemble';

  @override
  final String description = 'Disassemble a compiled program.';

  @override
  String get invocation =>
      '${runner!.executableName} $name <path/to/compiled/file>';

  @override
  Future<void> run() async {
    final String? compiledFilePathRaw = argResults!.rest.firstOrNull;
    if (compiledFilePathRaw == null) {
      printInvalidInvocation('Specify a file to disassemble.');
      return;
    }

    final String compiledFilePath = p.absolute(compiledFilePathRaw);
    final File compiledFile = File(compiledFilePath);
    if (!(await compiledFile.exists())) {
      print('Specified file "${compiledFile.path}" does not exist.');
      return;
    }

    try {
      final Uint8List bytes = await compiledFile.readAsBytes();
      final BeizeProgramConstant program =
          BeizeConstantSerializer.deserialize(bytes);
      BeizeDisassembler.disassembleProgram(program);
    } catch (err) {
      print('Disassembling "${compiledFile.path}" failed.');
      println();
      print(err);
    }
  }
}
