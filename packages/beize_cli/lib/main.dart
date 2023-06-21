import 'package:args/command_runner.dart';
import 'commands/exports.dart';

Future<void> main(final List<String> args) async {
  final CommandRunner<Future<void>> runner = CommandRunner<Future<void>>(
    'beize',
    'Beize Language CLI.',
  );
  runner.addCommand(RunCommand());
  runner.addCommand(CompileCommand());
  runner.addCommand(DisassembleCommand());
  runner.addCommand(InterpretCommand());
  try {
    await runner.run(args);
  } on UsageException catch (err) {
    print(err);
  }
}
