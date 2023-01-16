import '../bytecode.dart';
import '../values/exports.dart';

class FubukiRuntimeExpection implements Exception {
  FubukiRuntimeExpection(this.message);

  factory FubukiRuntimeExpection.invalidLeftOperandType(
    final String expected,
    final String received,
  ) =>
      FubukiRuntimeExpection(
        'Invalid left operand value type (expected "$expected", received "$received")',
      );

  factory FubukiRuntimeExpection.invalidRightOperandType(
    final String expected,
    final String received,
  ) =>
      FubukiRuntimeExpection(
        'Invalid right operand value type (expected "$expected", received "$received")',
      );

  factory FubukiRuntimeExpection.undefinedVariable(final String name) =>
      FubukiRuntimeExpection('Undefined variable "$name"');

  factory FubukiRuntimeExpection.cannotRedecalreVariable(final String name) =>
      FubukiRuntimeExpection('Cannot redeclare variable "$name"');

  factory FubukiRuntimeExpection.unknownOpCode(final FubukiOpCodes opCode) =>
      FubukiRuntimeExpection('Unknown op code: ${opCode.name}');

  factory FubukiRuntimeExpection.unknownConstant(final dynamic constant) =>
      FubukiRuntimeExpection('Unknown constant: $constant');

  factory FubukiRuntimeExpection.cannotCastTo(
    final FubukiValueKind expected,
    final FubukiValueKind received,
  ) =>
      FubukiRuntimeExpection(
        'Cannot cast "${received.code}" to "${expected.code}"',
      );

  factory FubukiRuntimeExpection.unwrapFailed(final String message) =>
      FubukiRuntimeExpection('Unwrap failed due to "$message"');

  final String message;

  @override
  String toString() => 'FubukiRuntimeExpection: $message';
}
