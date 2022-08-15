import '../ast/exports.dart';
import '../libraries/exports.dart';
import 'stack_trace.dart';

class OutreEvaluatorContext {
  OutreEvaluatorContext({
    required this.rootDir,
  });

  final String rootDir;

  final OutreStackTrace stackTrace = OutreStackTrace();
  final Map<String, OutreMirroredValue> importCache =
      <String, OutreMirroredValue>{
    OutreConsoleLibrary.name: OutreConsoleLibrary.module,
  };

  void popStackFrame() => stackTrace.pop();
  void pushStackFrame(final OutreStackFrame frame) {
    stackTrace.push(frame);
  }

  bool hasImportCache(final String path) => importCache.containsKey(path);
  OutreMirroredValue getImportCache(final String path) => importCache[path]!;
  void setImportCache(final String path, final OutreMirroredValue value) {
    importCache[path] = value;
  }
}
