// ignore_for_file: avoid_print

import 'package:beize_compiler/beize_compiler.dart';
import 'package:beize_vm/beize_vm.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  final BeizeProgramConstant program = await BeizeCompiler.compileProject(
    root: path.join(path.current, 'example/project'),
    entrypoint: 'dev.beize',
  );
  print(program.serialize());
  final BeizeProgramConstant real =
      BeizeProgramConstant.deserialize(program.serialize());
  BeizeDisassembler.disassembleProgram(real);
  final BeizeVM vm = BeizeVM(real, BeizeVMOptions());
  await vm.run();
}
