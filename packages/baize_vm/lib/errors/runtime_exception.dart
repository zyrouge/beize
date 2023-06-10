import '../bytecode.dart';
import '../values/exports.dart';

class BaizeRuntimeExpection implements Exception {
  BaizeRuntimeExpection(this.message);

  factory BaizeRuntimeExpection.invalidLeftOperandType(
    final String expected,
    final String received,
  ) =>
      BaizeRuntimeExpection(
        'Invalid left operand value type (expected "$expected", received "$received")',
      );

  factory BaizeRuntimeExpection.invalidRightOperandType(
    final String expected,
    final String received,
  ) =>
      BaizeRuntimeExpection(
        'Invalid right operand value type (expected "$expected", received "$received")',
      );

  factory BaizeRuntimeExpection.undefinedVariable(final String name) =>
      BaizeRuntimeExpection('Undefined variable "$name"');

  factory BaizeRuntimeExpection.cannotRedecalreVariable(final String name) =>
      BaizeRuntimeExpection('Cannot redeclare variable "$name"');

  factory BaizeRuntimeExpection.unknownOpCode(final BaizeOpCodes opCode) =>
      BaizeRuntimeExpection('Unknown op code: ${opCode.name}');

  factory BaizeRuntimeExpection.unknownConstant(final dynamic constant) =>
      BaizeRuntimeExpection('Unknown constant: $constant');

  factory BaizeRuntimeExpection.cannotCastTo(
    final BaizeValueKind expected,
    final BaizeValueKind received,
  ) =>
      BaizeRuntimeExpection(
        'Cannot cast "${received.code}" to "${expected.code}"',
      );

  factory BaizeRuntimeExpection.unwrapFailed(final String message) =>
      BaizeRuntimeExpection('Unwrap failed due to "$message"');

  final String message;

  @override
  String toString() => 'BaizeRuntimeExpection: $message';
}
