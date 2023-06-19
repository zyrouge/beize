import '../../errors/exports.dart';
import '../../vm/exports.dart';
import '../exports.dart';

class BeizeFunctionValueUtils {
  static BeizeInterpreterResult handleException(
    final BeizeCallFrame frame,
    final Object err,
    final StackTrace stackTrace,
  ) =>
      BeizeInterpreterResult.fail(createExceptionValue(frame, err, stackTrace));

  static BeizeExceptionValue createExceptionValue(
    final BeizeCallFrame frame,
    final Object err,
    final StackTrace stackTrace,
  ) {
    if (err is BeizeInterpreterBridgedException) {
      return err.error;
    }
    return BeizeExceptionValue(
      err is BeizeNativeException ? err.message : err.toString(),
      frame.getStackTrace(),
      stackTrace.toString(),
    );
  }
}
