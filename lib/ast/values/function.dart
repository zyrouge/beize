import '../../lexer/exports.dart';
import 'exports.dart';

typedef OutreFunctionValueNoArgumentsCall = Future<OutreValue> Function();

typedef OutreFunctionValueCallFn = Future<OutreValue> Function(
  OutreFunctionValueCall call,
);

abstract class OutreFunctionValueProperties {
  static const String kCall = 'call';
}

class OutreFunctionValue extends OutreValueFromProperties {
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

class OutreFunctionValueCall {
  const OutreFunctionValueCall(this.arguments);

  final List<OutreValue> arguments;

  OutreValue argAt(final int index) {
    if (index < arguments.length) {
      return arguments[index];
    }
    return OutreNullValue();
  }

  static OutreFunctionValueCall empty =
      const OutreFunctionValueCall(<OutreValue>[]);
}
