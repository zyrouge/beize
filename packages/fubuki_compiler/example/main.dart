import 'package:fubuki_compiler/exports.dart';
import 'package:fubuki_vm/exports.dart';
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
  print(vm.stack);
}
