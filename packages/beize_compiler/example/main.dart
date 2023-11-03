// ignore_for_file: avoid_print

import 'package:beize_compiler/beize_compiler.dart';
import 'package:beize_vm/beize_vm.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final BeizeProgramConstant program = await BeizeCompiler.compileProject(
    root: p.join(p.current, 'example/project'),
    entrypoint: 'main.beize',
    options: BeizeCompilerOptions(),
  );
  final BeizeSerializedConstant serialized = program.serialize();
  print(serialized);
  final BeizeProgramConstant real =
      BeizeProgramConstant.deserialize(serialized);
  BeizeDisassembler.disassembleProgram(real);
  final BeizeVM vm = BeizeVM(real, BeizeVMOptions());
  await vm.run();
}
