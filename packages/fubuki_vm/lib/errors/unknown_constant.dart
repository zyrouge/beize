import '../exports.dart';

class FubukiUnknownConstantExpection implements Exception {
  FubukiUnknownConstantExpection(this.message);

  factory FubukiUnknownConstantExpection.unknownSerializedConstant(
    final FubukiConstant constant,
  ) =>
      FubukiUnknownConstantExpection('Unknown serialized constant: $constant');

  final String message;

  @override
  String toString() => 'FubukiUnknownConstantExpection: $message';
}
