typedef BaizeReporterLogFn = void Function(String report);

class BaizeReporter {
  const BaizeReporter({
    this.log = defaultLog,
  });

  final BaizeReporterLogFn? log;

  void reportError(final String name, final String text) {
    final String output = '[error] $name: $text';
    log?.call(output);
  }

  static void defaultLog(final String report) {
    // ignore: avoid_print
    print(report);
  }
}
