import '../ast/exports.dart';
import '../errors/exports.dart';
import '../libraries/exports.dart';
import '../node/exports.dart';
import 'stack_trace.dart';

class OutreEnvironment {
  OutreEnvironment(
    this.outer, {
    required this.frameName,
    required this.file,
    this.isInsideFunction = false,
    this.isInsideLoop = false,
    final bool withGlobalValues = false,
  }) {
    if (withGlobalValues) {
      addGlobalValues(this);
    }
  }

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
      throw OutreUntracedRuntimeException('Cannot redeclare variable "$name"');
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
      throw OutreUntracedRuntimeException(
        'Cannot assign to unknown variable "$name"',
      );
    }
    outer!.assign(name, value);
  }

  OutreValue get(final String name) {
    if (values.containsKey(name)) {
      return values[name]!;
    }
    if (outer == null) {
      throw OutreUntracedRuntimeException(
        'Cannot access unknown variable "$name"',
      );
    }
    return outer!.get(name);
  }

  OutreStackFrame createStackFrameFromOutreNode(final OutreNode node) =>
      OutreStackFrame(frameName, file, node.span);

  static void addGlobalValues(final OutreEnvironment environment) {
    environment.declare(
      OutreGlobalPromiseValue.name,
      OutreGlobalPromiseValue.value,
    );
    environment.declare(
      OutreGlobalObjectValue.name,
      OutreGlobalObjectValue.value,
    );
    environment.declare(
      OutreGlobalDateTimeValue.name,
      OutreGlobalDateTimeValue.value,
    );
  }
}
