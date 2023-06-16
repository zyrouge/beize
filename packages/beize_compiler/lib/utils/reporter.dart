typedef BeizeReporterLogFn = void Function(String report);

class BeizeReporter {
  const BeizeReporter({
    this.log = defaultLog,
  });

  final BeizeReporterLogFn? log;

  void reportError(final String name, final String text) {
    final String output = '[error] $name: $text';
    log?.call(output);
  }

  static void defaultLog(final String report) {
    // ignore: avoid_print
    print(report);
  }
}
