// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:outre/outre.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

final String testDir = path.join(Directory.current.path, 'test');
final String testDataDir = path.join(testDir, 'test-data');

Future<void> main() async {
  test('Hello World!', () async {
    final String code =
        await File(path.join(testDir, 'parser_test.outre')).readAsString();

    final OutreInput input = OutreInput(code);
    final OutreScanner scanner = OutreScanner(input);
    final List<OutreToken> tokens = scanner.scan();
    final OutreParser parser = OutreParser(tokens);
    final OutreProgram program = parser.parse();

    final dynamic ast = program.toJson();
    print(const JsonEncoder.withIndent('  ').convert(ast));
    expect(OutreNode.fromJson(ast) is OutreProgram, true);

    await File(path.join(testDataDir, 'parser_test_ast.json'))
        .writeAsString(json.encode(ast));
  });
}
