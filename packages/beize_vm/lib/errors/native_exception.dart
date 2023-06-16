class BeizeNativeException implements Exception {
  BeizeNativeException(this.message);

  final String message;

  @override
  String toString() => 'BeizeNativeException: $message';
}
