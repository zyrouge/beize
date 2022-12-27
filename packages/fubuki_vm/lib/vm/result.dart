import '../values/exports.dart';

enum FubukiInterpreterResultState {
  success,
  fail,
}

class FubukiInterpreterResult {
  const FubukiInterpreterResult._(this.state, this.value);

  factory FubukiInterpreterResult.success(final FubukiValue value) =>
      FubukiInterpreterResult._(FubukiInterpreterResultState.success, value);

  factory FubukiInterpreterResult.fail(final FubukiValue value) =>
      FubukiInterpreterResult._(FubukiInterpreterResultState.fail, value);

  final FubukiInterpreterResultState state;
  final FubukiValue value;

  bool get isSuccess => state == FubukiInterpreterResultState.success;
  bool get isFailure => state == FubukiInterpreterResultState.fail;
}
