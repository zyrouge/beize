class FubukiNativeException implements Exception {
  FubukiNativeException(this.message);

  final String message;

  @override
  String toString() => 'FubukiNativeException: $message';
}
