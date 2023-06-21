import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:beize_vm/beize_vm.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import '../utils.dart';

class InterpretCommand extends Command<Future<void>> {
  InterpretCommand() {
    argParser.addFlag(
      disablePrintFlag,
      help: 'Disable native print function.',
      negatable: false,
    );
  }

  @override
  final String name = 'interpret';

  @override
  final List<String> aliases = <String>['run-compiled', 'execute-compiled'];

  @override
  final String description = 'Interpret a compiled program.';

  @override
  String get invocation => '${runner!.executableName} $name <path/to/compiled>';

  @override
  Future<void> run() async {
    final String? compiledFilePathRaw = argResults!.rest.firstOrNull;
    final bool disablePrint = argResults![disablePrintFlag] as bool;
    if (compiledFilePathRaw == null) {
      printInvalidInvocation('Specify a file to interpret.');
      return;
    }

    final String compiledFilePath = p.absolute(compiledFilePathRaw);
    final File compiledFile = File(compiledFilePath);
    if (!(await compiledFile.exists())) {
      print('Specified file "${compiledFile.path}" does not exist.');
    }

    late final BeizeProgramConstant program;
    try {
      final String content = await compiledFile.readAsString();
      final List<dynamic> parsed = json.decode(content) as List<dynamic>;
      program = BeizeProgramConstant.deserialize(parsed);
    } catch (err) {
      print('Parsing "${compiledFile.path}" failed.');
      println();
      print(err);
    }

    try {
      final BeizeVM vm = BeizeVM(
        program,
        BeizeVMOptions(
          disablePrint: disablePrint,
          printPrefix: '',
        ),
      );
      await vm.run();
    } catch (err) {
      print(err);
    }
  }

  static const String disablePrintFlag = 'disable-print';
}
