class BaizeNativeException implements Exception {
  BaizeNativeException(this.message);

  final String message;

  @override
  String toString() => 'BaizeNativeException: $message';
}
