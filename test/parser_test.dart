// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:outre/outre.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'utils.dart';

Future<void> main() async {
  test('Hello World!', () async {
    final String inputFile =
        path.join(OutreTestPaths.testDir, 'parser_test.outre');
    final String source = await File(inputFile).readAsString();

    final OutreInput input = OutreInput(source);
    final OutreScanner scanner = OutreScanner(input);
    final OutreScannerResult result = scanner.scan();
    if (result.hasErrors) {
      print('Exiting as scanner returned errors');
      exit(1);
    }

    final OutreParser parser = OutreParser(result.tokens);
    final OutreModule module = parser.parse();

    final dynamic jsonAst = module.toJson();
    final String prettyAst =
        const JsonEncoder.withIndent('  ').convert(jsonAst);
    final String unprettyAst = json.encode(jsonAst);

    print(prettyAst);
    expect(OutreNode.fromJson(jsonAst) is OutreModule, true);

    final String prettyAstFile =
        path.join(OutreTestPaths.testDataDir, 'parser_test_pretty_ast.json');
    await File(prettyAstFile).writeAsString(prettyAst);

    final String unprettyAstFile =
        path.join(OutreTestPaths.testDataDir, 'parser_test_unpretty_ast.json');
    await File(unprettyAstFile).writeAsString(unprettyAst);
  });
}
