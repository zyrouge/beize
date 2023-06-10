import '../values/exports.dart';

enum BaizeInterpreterResultState {
  success,
  fail,
}

class BaizeInterpreterResult {
  const BaizeInterpreterResult._(this.state, this.value);

  factory BaizeInterpreterResult.success(final BaizeValue value) =>
      BaizeInterpreterResult._(BaizeInterpreterResultState.success, value);

  factory BaizeInterpreterResult.fail(final BaizeValue value) =>
      BaizeInterpreterResult._(BaizeInterpreterResultState.fail, value);

  final BaizeInterpreterResultState state;
  final BaizeValue value;

  bool get isSuccess => state == BaizeInterpreterResultState.success;
  bool get isFailure => state == BaizeInterpreterResultState.fail;
}
