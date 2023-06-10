class BaizeUnhandledExpection implements Exception {
  BaizeUnhandledExpection(this.message);

  final String message;

  @override
  String toString() => 'BaizeUnhandledExpection: $message';
}
