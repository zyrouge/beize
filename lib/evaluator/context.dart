import 'stack_trace.dart';

class OutreContext {
  final OutreStackTrace stackTrace = OutreStackTrace();

  void pushStackFrame(final OutreStackFrame frame) {
    stackTrace.push(frame);
  }

  void popStackFrame() => stackTrace.pop();
}
