import 'package:fubuki_compiler/exports.dart';
import 'package:fubuki_vm/exports.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final FubukiProgramConstant program = await FubukiCompiler.compileProject(
    root: path.join(path.current, 'example/project'),
    entrypoint: 'main.fbs',
  );
  print(program.serialize());
  final FubukiProgramConstant real =
      FubukiProgramConstant.deserialize(program.serialize());
  FubukiDisassembler.disassembleProgram(real);
  final FubukiVM vm = FubukiVM(real);
  await vm.run();
}
