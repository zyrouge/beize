import 'dart:io';
import 'package:beize_compiler/beize_compiler.dart';
import 'package:beize_vm/beize_vm.dart';
import 'package:path/path.dart' as p;

final String testsDir = p.join(Directory.current.path, 'tests');

Future<BeizeProgramConstant> compileTestScript(
  final String dir,
  final String scriptName,
) async {
  final BeizeProgramConstant program = await BeizeCompiler.compileProject(
    root: p.join(testsDir, dir),
    entrypoint: scriptName,
    options: BeizeCompilerOptions(),
  );
  return program;
}

Future<List<String>> executeTestScript(
  final BeizeProgramConstant program,
) async {
  final BeizeVM vm = BeizeVM(program, BeizeVMOptions());
  final List<String> output = <String>[];
  final BeizeNativeFunctionValue out = BeizeNativeFunctionValue.sync(
    (final BeizeCallableCall call) {
      final BeizeStringValue value = call.argumentAt(0).cast();
      output.add(value.value);
      return BeizeNullValue.value;
    },
  );
  vm.globalNamespace.declare('out', out);
  await vm.run();
  return output;
}
