import '../node/exports.dart';
import 'stack_trace.dart';
import 'values/exports.dart';

class OutreEnvironment {
  OutreEnvironment(
    this.outer, {
    required this.frameName,
    required this.file,
    this.isInsideFunction = false,
    this.isInsideLoop = false,
  });

  final OutreEnvironment? outer;
  final String frameName;
  final String file;
  final bool isInsideFunction;
  final bool isInsideLoop;

  final Map<String, OutreValue> values = <String, OutreValue>{};

  OutreEnvironment wrap({
    final String? file,
    final String? frameName,
    final bool? isInsideFunction,
    final bool? isInsideLoop,
  }) =>
      OutreEnvironment(
        this,
        file: file ?? this.file,
        frameName: frameName ?? this.frameName,
        isInsideFunction: isInsideFunction ?? this.isInsideFunction,
        isInsideLoop: isInsideLoop ?? this.isInsideLoop,
      );

  void declare(final String name, final OutreValue value) {
    if (values.containsKey(name)) {
      throw Exception('Already declared: $name');
    }
    values[name] = value;
  }

  void declareMany(final Map<String, OutreValue> values) {
    values.forEach((final String k, final OutreValue v) {
      declare(k, v);
    });
  }

  void assign(final String name, final OutreValue value) {
    if (values.containsKey(name)) {
      values[name] = value;
      return;
    }
    if (outer == null) {
      throw Exception('Variable not found: $name');
    }
    outer!.assign(name, value);
  }

  OutreValue get(final String name) {
    if (values.containsKey(name)) {
      return values[name]!;
    }
    if (outer == null) {
      throw Exception('Variable not found');
    }
    return outer!.get(name);
  }

  OutreStackFrame createStackFrameFromOutreNode(final OutreNode node) =>
      OutreStackFrame(frameName, file, node.span);
}
