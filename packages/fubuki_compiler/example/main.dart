import 'package:fubuki_compiler/exports.dart';
import 'package:fubuki_vm/exports.dart';

Future<void> main() async {
  final FubukiInput input = FubukiInput(
    '''
values := list [1.2, 2];
print values[0.2];
''',
  );
  final FubukiScanner scanner = FubukiScanner(input);
  final FubukiCompiler compiler = FubukiCompiler(
    scanner,
    mode: FubukiCompilerMode.script,
    module: '<script>',
  );
  compiler.prepare();
  final FubukiFunctionConstant program = compiler.compile();
  FubukiDisassembler.printDissassembled(program);
  final FubukiVM vm = FubukiVM(program);
  await vm.run();
}
