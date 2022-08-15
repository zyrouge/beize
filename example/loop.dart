import 'dart:io';
import 'package:outre/outre.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final String source = p.join(
    Directory.current.path,
    'example/loop.outre',
  );
  await OutreEvaluator.evaluateFile(source);
}
