import 'package:args/command_runner.dart';

extension CommandUtils<T> on Command<T> {
  void printInvalidInvocation(final String message) {
    print(message);
    println();
    printUsageWithoutDescription();
  }

  void printUsageWithoutDescription() {
    print(usageWithoutDescription);
  }

  String get usageWithoutDescription =>
      usage.substring('$description\n\n'.length);
}

void println() {
  print('');
}
