import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:beize_compiler/beize_compiler.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import '../utils.dart';

class CompileCommand extends Command<Future<void>> {
  CompileCommand() {
    argParser.addOption(
      outputOption,
      abbr: 'o',
      help: 'Output file path.',
    );
    argParser.addFlag(
      disablePrintFlag,
      help: 'Disable native print function.',
      negatable: false,
    );
  }

  @override
  final String name = 'compile';

  @override
  final String description = 'Compile a program.';

  @override
  String get invocation =>
      '${runner!.executableName} $name <path/to/file> -o <path/to/output>';

  @override
  Future<void> run() async {
    final String? entrypointRaw = argResults!.rest.firstOrNull;
    final String? outputRaw = argResults![outputOption] as String?;
    final bool disablePrint = argResults![disablePrintFlag] as bool;
    if (entrypointRaw == null) {
      printInvalidInvocation('Specify a file to compile.');
      return;
    }
    if (outputRaw == null) {
      printInvalidInvocation('Specify an output to compile to.');
      return;
    }

    final String root = p.current;
    final String entrypoint = p.absolute(entrypointRaw);
    final String output = p.absolute(outputRaw);

    final File outputFile = File(output);
    if (!(await outputFile.parent.exists())) {
      print('Output file directory "${outputFile.parent.path}" is missing.');
    }

    try {
      final BeizeProgramConstant program = await BeizeCompiler.compileProject(
        root: root,
        entrypoint: entrypoint,
        options: BeizeCompilerOptions(
          disablePrint: disablePrint,
        ),
      );
      final List<dynamic> serialized = program.serialize();
      await outputFile.writeAsString(json.encode(serialized));
      print('Compiled to "${p.normalize(output)}"!');
    } catch (err) {
      print('Compilation of "$entrypoint" failed.');
      println();
      print(err);
    }
  }

  static const String outputOption = 'output';
  static const String disablePrintFlag = 'disable-print';
}
