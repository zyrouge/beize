import '../../lexer/exports.dart';
import 'exports.dart';

typedef OutreFunctionValueNoArgumentsCall = OutreValue Function();

typedef OutreFunctionValueCallFn = OutreValue Function(
  List<OutreValue> arguments,
);

abstract class OutreFunctionValueProperties {
  static const String kCall = 'call';
}

class OutreFunctionValue extends OutreValue {
  OutreFunctionValue(this.arity, this._call) : super(OutreValues.functionValue);

  factory OutreFunctionValue.fromOutreValue(final OutreValue value) =>
      OutreFunctionValue.noArgumentsFunction(() => value);

  factory OutreFunctionValue.noArgumentsFunction(
    final OutreFunctionValueNoArgumentsCall fn,
  ) =>
      OutreFunctionValue(0, (final _) => fn());

  final int arity;
  final OutreFunctionValueCallFn _call;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    OutreFunctionValueProperties.kCall: this,
    OutreValueProperties.kToString:
        OutreStringValue(OutreTokens.fnKw.code).asOutreFunctionValue(),
  };

  OutreValue call(final List<OutreValue> arguments) {
    if (arguments.length != arity) {
      throw Exception('Invalid number of arguments');
    }
    return _call(arguments);
  }
}
