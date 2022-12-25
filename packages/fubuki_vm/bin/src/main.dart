import 'package:args/command_runner.dart';
import 'commands/exports.dart';

Future<void> main(final List<String> args) async {
  final CommandRunner<void> app = CommandRunner<void>('outre', '');
  app.addCommand(RunCommand());
  await app.run(args);
}
