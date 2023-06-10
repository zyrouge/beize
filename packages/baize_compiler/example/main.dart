// ignore_for_file: avoid_print

import 'package:baize_compiler/baize_compiler.dart';
import 'package:baize_vm/baize_vm.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final BaizeProgramConstant program = await BaizeCompiler.compileProject(
    root: path.join(path.current, 'example/project'),
    entrypoint: 'dev.fbs',
  );
  print(program.serialize());
  final BaizeProgramConstant real =
      BaizeProgramConstant.deserialize(program.serialize());
  BaizeDisassembler.disassembleProgram(real);
  final BaizeVM vm = BaizeVM(real, BaizeVMOptions());
  await vm.run();
}
