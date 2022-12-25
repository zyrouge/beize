import 'package:fubuki_compiler/exports.dart';
import 'package:fubuki_vm/exports.dart';

Future<void> main() async {
  final FubukiInput input = FubukiInput(
    '''
hi := list [1, 2, 3];
hi.forEach(fun (x) {
  print x;
});
''',
  );
  final FubukiScanner scanner = FubukiScanner(input);
  final FubukiCompiler compiler = FubukiCompiler(
    scanner,
    mode: FubukiCompilerMode.script,
  );
  compiler.prepare();
  final FubukiFunctionConstant program = compiler.compile();
  FubukiDisassembler.printDissassembled(program);
  final FubukiVM vm = FubukiVM(program);
  await vm.run();
}
