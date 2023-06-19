import '../values/exports.dart';

class BeizeInterpreterBridgedException implements Exception {
  BeizeInterpreterBridgedException(this.error);

  final BeizeExceptionValue error;

  @override
  String toString() =>
      'BeizeInterpreterBridgedException: ${error.toCustomString(includePrefix: false)}';
}
