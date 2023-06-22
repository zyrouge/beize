import '../bytecode.dart';
import '../values/exports.dart';
import 'native_exception.dart';

class BeizeRuntimeExpection extends BeizeNativeException {
  BeizeRuntimeExpection(super.message);

  factory BeizeRuntimeExpection.invalidLeftOperandType(
    final String expected,
    final String received,
  ) =>
      BeizeRuntimeExpection(
        'Invalid left operand value type (expected "$expected", received "$received")',
      );

  factory BeizeRuntimeExpection.invalidRightOperandType(
    final String expected,
    final String received,
  ) =>
      BeizeRuntimeExpection(
        'Invalid right operand value type (expected "$expected", received "$received")',
      );

  factory BeizeRuntimeExpection.undefinedVariable(final String name) =>
      BeizeRuntimeExpection('Undefined variable "$name"');

  factory BeizeRuntimeExpection.cannotRedecalreVariable(final String name) =>
      BeizeRuntimeExpection('Cannot redeclare variable "$name"');

  factory BeizeRuntimeExpection.unknownOpCode(final BeizeOpCodes opCode) =>
      BeizeRuntimeExpection('Unknown op code: ${opCode.name}');

  factory BeizeRuntimeExpection.unknownConstant(final dynamic constant) =>
      BeizeRuntimeExpection('Unknown constant: $constant');

  factory BeizeRuntimeExpection.cannotCastTo(
    final BeizeValueKind expected,
    final BeizeValueKind received,
  ) =>
      BeizeRuntimeExpection(
        'Cannot cast "${received.code}" to "${expected.code}"',
      );

  factory BeizeRuntimeExpection.unwrapFailed(final String message) =>
      BeizeRuntimeExpection('Unwrap failed due to "$message"');

  factory BeizeRuntimeExpection.cannotConvertDoubleToInteger(
    final double value,
  ) =>
      BeizeRuntimeExpection('Cannot convert "$value" to integer');

  factory BeizeRuntimeExpection.unexpectedArgumentType(
    final int index,
    final BeizeValueKind expected,
    final BeizeValueKind received,
  ) =>
      BeizeRuntimeExpection(
        'Expected argument at $index to be "${expected.code}", received "${received.code}"',
      );

  @override
  String toString() => 'BeizeRuntimeExpection: $message';
}
