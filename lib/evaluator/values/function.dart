import '../../lexer/exports.dart';
import 'exports.dart';

typedef OutreFunctionValueNoArgumentsCall = Future<OutreValue> Function();

typedef OutreFunctionValueCallFn = Future<OutreValue> Function(
  List<OutreValue> arguments,
);

abstract class OutreFunctionValueProperties {
  static const String kCall = 'call';
}

class OutreFunctionValue extends OutreValue {
  OutreFunctionValue(this.call) : super(OutreValues.functionValue);

  factory OutreFunctionValue.fromOutreValue(final OutreValue value) =>
      OutreFunctionValue((final _) async => value);

  final OutreFunctionValueCallFn call;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreFunctionValueProperties.kCall: this,
    OutreValueProperties.kToString:
        OutreStringValue(OutreTokens.fnKw.code).asOutreFunctionValue(),
  };
}
