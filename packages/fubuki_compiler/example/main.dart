// ignore_for_file: avoid_print

import 'package:fubuki_compiler/fubuki_compiler.dart';
import 'package:fubuki_vm/fubuki_vm.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final FubukiProgramConstant program = await FubukiCompiler.compileProject(
    root: path.join(path.current, 'example/project'),
    entrypoint: 'dev.fbs',
  );
  print(program.serialize());
  final FubukiProgramConstant real =
      FubukiProgramConstant.deserialize(program.serialize());
  FubukiDisassembler.disassembleProgram(real);
  final FubukiVM vm = FubukiVM(real, FubukiVMOptions());
  await vm.run();
}
