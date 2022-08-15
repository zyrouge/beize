import 'package:args/command_runner.dart';
import 'package:outre/outre.dart';
import 'package:path/path.dart' as p;

class RunCommand extends Command<void> {
  @override
  final String name = 'run';

  @override
  final String description = 'Run an outre program directly';

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty) {
      throw Exception('Missing input file');
    }

    final String file = argResults!.rest.first;
    final String path = p.isAbsolute(file) ? file : p.absolute(file);
    await OutreEvaluator.evaluateFile(path);
  }
}
