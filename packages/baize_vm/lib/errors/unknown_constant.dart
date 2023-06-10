import '../bytecode.dart';

class BaizeUnknownConstantExpection implements Exception {
  BaizeUnknownConstantExpection(this.message);

  factory BaizeUnknownConstantExpection.unknownSerializedConstant(
    final BaizeConstant constant,
  ) =>
      BaizeUnknownConstantExpection('Unknown serialized constant: $constant');

  final String message;

  @override
  String toString() => 'BaizeUnknownConstantExpection: $message';
}
