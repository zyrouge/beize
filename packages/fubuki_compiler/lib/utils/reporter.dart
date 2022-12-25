typedef FubukiReporterLogFn = void Function(String report);

class FubukiReporter {
  const FubukiReporter({
    this.log = defaultLog,
  });

  final FubukiReporterLogFn? log;

  void reportError(final String name, final String text) {
    final String output = '[error] $name: $text';
    log?.call(output);
  }

  static void defaultLog(final String report) {
    // ignore: avoid_print
    print(report);
  }
}
