import '../vm/exports.dart';
import 'exports.dart';

class BeizeExceptionValue extends BeizePrimitiveObjectValue {
  BeizeExceptionValue(this.message, this.stackTrace, [this.dartStackTrace]);

  final String message;
  final String stackTrace;
  final StackTrace? dartStackTrace;

  @override
  final String kName = 'Exception';

  @override
  BeizeValue get(final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'message':
          return BeizeStringValue(message);

        case 'stackTrace':
          return BeizeStringValue(stackTrace);

        default:
      }
    }
    return super.get(key);
  }

  @override
  BeizeExceptionClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.globals.exceptionClass;

  @override
  BeizeExceptionValue kClone() =>
      BeizeExceptionValue(message, stackTrace, dartStackTrace);

  @override
  String kToString() => 'Exception: $message\nStack Trace:\n$stackTrace';

  String toCustomString({
    final bool includePrefix = true,
  }) {
    final StringBuffer buffer = StringBuffer();
    if (includePrefix) {
      buffer.write('BeizeExceptionValue: ');
    }
    buffer.writeln(message);
    buffer.writeln('Beize Stack Trace:');
    buffer.writeln(stackTrace);
    if (dartStackTrace != null) {
      buffer.writeln('--- Previous Dart Stack Trace:');
      buffer.writeln(dartStackTrace.toString().trimRight());
      buffer.writeln('--- [end] Previous Dart Stack Trace');
    }
    return buffer.toString();
  }

  @override
  String toString() => toCustomString();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => Object.hash(message, stackTrace, dartStackTrace);
}
