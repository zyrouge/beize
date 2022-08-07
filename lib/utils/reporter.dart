typedef OutreReporterPrintFn = void Function(String report);

class OutreReporter {
  const OutreReporter({
    this.printFn = defaultPrintFn,
  });

  final OutreReporterPrintFn? printFn;

  void reportError(final String name, final String text) {
    final String output = '[error] $name: $text';
    printFn?.call(output);
  }

  static void defaultPrintFn(final String report) {
    // ignore: avoid_print
    print(report);
  }
}
