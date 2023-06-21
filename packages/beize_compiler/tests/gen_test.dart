// ignore_for_file: unreachable_from_main, avoid_print

import 'dart:io';
import 'package:beize_compiler/beize_compiler.dart';
import 'package:path/path.dart' as p;
import 'utils.dart';

Future<void> main() async {
  final TestOptions options = TestOptions(
    category: 'Operator',
    title: 'Grouping',
    index: 1,
    output: <String>['28'],
    script: '''
result := (2 + 5) * 4;
out("" + result);
''',
    moduleAt: 0,
  );
  await options.parentDir.ensure();
  print('Parent Dir: ${options.parentDirPath}');
  if (await options.beizeFile.exists()) {
    print('"${options.beizeFilePath}" exists already.');
    return;
  }
  if (await options.dartTestFile.exists()) {
    print('"${options.dartTestFilePath}" exists already.');
    return;
  }
  await options.beizeFile.writeAsString(options.script);
  print('Beize File: ${options.beizeFilePath}');
  await options.dartTestFile
      .writeAsString(await generateTestDart(options: options));
  print('Dart File: ${options.dartTestFilePath}');
  print('');

  final Process testProcess = await Process.start(
    'dart',
    <String>['test', p.relative(options.dartTestFilePath)],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  await testProcess.exitCode;
}

class TestOptions {
  TestOptions({
    required this.category,
    required this.title,
    required this.index,
    required this.output,
    required this.script,
    required this.moduleAt,
  });

  final String category;
  final String title;
  final int index;
  final List<String> output;
  final String script;
  final int moduleAt;

  String toPathName(final String text) =>
      text.replaceAll(RegExp(r'\s+'), '_').toLowerCase();

  String get parentDirName => toPathName('${title}_$category');
  String get beizeFileName => toPathName('${title}_$index.beize');
  String get dartTestFileName => toPathName('${title}_${index}_test.dart');

  String get parentDirPath => p.join(rootDir, parentDirName);
  String get beizeFilePath => p.join(parentDirPath, beizeFileName);
  String get dartTestFilePath => p.join(parentDirPath, dartTestFileName);

  Directory get parentDir => Directory(parentDirPath);
  File get beizeFile => File(beizeFilePath);
  File get dartTestFile => File(dartTestFilePath);

  static final String rootDir = p.absolute('tests');
}

Future<String> generateTestDart({
  required final TestOptions options,
}) async {
  final BeizeProgramConstant program = await BeizeCompiler.compileProject(
    root: options.parentDirPath,
    entrypoint: options.beizeFileName,
    options: BeizeCompilerOptions(),
  );
  final String expectedChunkCode =
      buildExpectedChunkCode(program.moduleAt(options.moduleAt).chunk);
  return '''
import 'package:beize_compiler/beize_compiler.dart';
import 'package:test/test.dart';
import '../utils.dart';

Future<void> main() async {
  const String title = '[${options.category}] ${options.title} (${options.index})';
  final BeizeProgramConstant program =
      await compileTestScript('${options.parentDirName}', '${options.beizeFileName}');

  test('\$title - Bytecode', () async {
    final BeizeChunk chunk = extractChunk(program);
    $expectedChunkCode
    expect(tcpc(chunk), tcptc(expectedChunk));
  });

  test('\$title - Channel', () async {
    final List<String> expected = <String>[${options.output.map((final String x) => "'$x'").join(', ')}];
    final List<String> actual = await executeTestScript(program);
    expect(actual, orderedEquals(expected));
  });
}
''';
}

extension on Directory {
  Future<void> ensure() async {
    if (!(await exists())) {
      await create(recursive: true);
    }
  }
}
