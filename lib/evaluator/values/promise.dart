import 'exports.dart';

class OutrePromiseValue extends OutreValue {
  OutrePromiseValue(this.value) : super(OutreValues.promiseValue);

  final Future<OutreValue> value;

  @override
  late final Map<OutreValuePropertyKey, OutreValue> properties =
      <OutreValuePropertyKey, OutreValue>{
    'then': OutreFunctionValue(
      (final List<OutreValue> arguments) async {
        final OutreFunctionValue cb = arguments.first.cast();
        value.then((final OutreValue x) {
          cb.call(<OutreValue>[x]);
        });
        return OutreNullValue();
      },
    ),
    'catch': OutreFunctionValue(
      (final List<OutreValue> arguments) async {
        final OutreFunctionValue cb = arguments.first.cast();
        value.catchError((final Object err) {
          cb.call(<OutreValue>[
            OutreValueUtils.toOutreValue(err),
          ]);
        });
        return OutreNullValue();
      },
    ),
  };

  Future<OutreValue> resolve() async => value;
}
