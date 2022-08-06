import 'dart:io';
import 'package:path/path.dart' as path;

abstract class OutreTestUtils {
  static Future<void> ensureDir(final Directory dir) async {
    if (await dir.exists()) return;
    await dir.create(recursive: true);
  }
}

abstract class OutreTestPaths {
  static final String testDir = path.join(Directory.current.path, 'test');
  static final String testDataDir = path.join(testDir, 'test-data');

  static Future<void> initialize() async {
    await OutreTestUtils.ensureDir(Directory(testDataDir));
  }
}
