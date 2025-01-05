import '../bytecode.dart';
import 'native_exception.dart';

class BeizeRuntimeException extends BeizeNativeException {
  BeizeRuntimeException(super.message);

  factory BeizeRuntimeException.invalidLeftOperandType(
    final String expected,
    final String received,
  ) =>
      BeizeRuntimeException(
        'Invalid left operand value type (expected "$expected", received "$received")',
      );

  factory BeizeRuntimeException.invalidRightOperandType(
    final String expected,
    final String received,
  ) =>
      BeizeRuntimeException(
        'Invalid right operand value type (expected "$expected", received "$received")',
      );

  factory BeizeRuntimeException.undefinedVariable(final String name) =>
      BeizeRuntimeException('Undefined variable "$name"');

  factory BeizeRuntimeException.cannotRedeclareVariable(final String name) =>
      BeizeRuntimeException('Cannot redeclare variable "$name"');

  factory BeizeRuntimeException.unknownOpCode(final BeizeOpCodes opCode) =>
      BeizeRuntimeException('Unknown op code: ${opCode.name}');

  factory BeizeRuntimeException.unknownConstant(final dynamic constant) =>
      BeizeRuntimeException('Unknown constant: $constant');

  factory BeizeRuntimeException.cannotCastTo(
    final String expected,
    final String received,
  ) =>
      BeizeRuntimeException(
        'Cannot cast "$received" to "$expected"',
      );

  factory BeizeRuntimeException.unwrapFailed(final String message) =>
      BeizeRuntimeException('Unwrap failed due to "$message"');

  factory BeizeRuntimeException.cannotConvertDoubleToInteger(
    final double value,
  ) =>
      BeizeRuntimeException('Cannot convert "$value" to integer');

  factory BeizeRuntimeException.unexpectedArgumentType(
    final int index,
    final String expected,
    final String received,
  ) =>
      BeizeRuntimeException(
        'Expected argument at $index to be "$expected", received "$received"',
      );

  factory BeizeRuntimeException.notCallable(final String value) =>
      BeizeRuntimeException('Value "$value" is not callable');

  @override
  String toString() => 'BeizeRuntimeException: $message';
}
