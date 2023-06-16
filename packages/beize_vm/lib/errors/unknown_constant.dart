import '../bytecode.dart';

class BeizeUnknownConstantExpection implements Exception {
  BeizeUnknownConstantExpection(this.message);

  factory BeizeUnknownConstantExpection.unknownSerializedConstant(
    final BeizeConstant constant,
  ) =>
      BeizeUnknownConstantExpection('Unknown serialized constant: $constant');

  final String message;

  @override
  String toString() => 'BeizeUnknownConstantExpection: $message';
}
