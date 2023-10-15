import '../errors/exports.dart';
import '../values/exports.dart';

enum BeizeInterpreterResultState {
  success,
  fail,
}

class BeizeInterpreterResult {
  const BeizeInterpreterResult._(this.state, this.value);

  factory BeizeInterpreterResult.success(final BeizeValue value) =>
      BeizeInterpreterResult._(BeizeInterpreterResultState.success, value);

  factory BeizeInterpreterResult.fail(final BeizeExceptionValue value) =>
      BeizeInterpreterResult._(BeizeInterpreterResultState.fail, value);

  final BeizeInterpreterResultState state;
  final BeizeValue value;

  BeizeExceptionValue get error => value.cast();

  bool get isSuccess => state == BeizeInterpreterResultState.success;
  bool get isFailure => state == BeizeInterpreterResultState.fail;
}

extension BeizeValueInterpreterResultUtils on BeizeInterpreterResult {
  BeizeValue unwrapUnsafe() {
    if (isFailure) {
      throw BeizeInterpreterBridgedException(error);
    }
    return value;
  }
}

extension BeizeValueFutureInterpreterResultUtils
    on Future<BeizeInterpreterResult> {
  Future<BeizeValue> unwrapUnsafe() async {
    final BeizeInterpreterResult result = await this;
    return result.unwrapUnsafe();
  }
}
