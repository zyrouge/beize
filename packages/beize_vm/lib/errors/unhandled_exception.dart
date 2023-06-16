class BeizeUnhandledExpection implements Exception {
  BeizeUnhandledExpection(this.message);

  final String message;

  @override
  String toString() => 'BeizeUnhandledExpection: $message';
}
