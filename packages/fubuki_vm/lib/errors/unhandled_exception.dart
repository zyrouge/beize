class FubukiUnhandledExpection implements Exception {
  FubukiUnhandledExpection(this.message);

  final String message;

  @override
  String toString() => 'FubukiUnhandledExpection: $message';
}
