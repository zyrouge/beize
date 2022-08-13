import 'dart:async';
import '../evaluator/exports.dart';

abstract class OutrePromiseLib {
  static const String name = 'outre:promise';

  static final OutreObjectValue value = OutreObjectValue(
    <OutreValuePropertyKey, OutreValue>{
      'create': OutreFunctionValue(
        (final _) async {
          final Completer<OutreValue> completer = Completer<OutreValue>();
          final OutrePromiseValue value = OutrePromiseValue(completer.future);
          return OutreObjectValue(
            <OutreValuePropertyKey, OutreValue>{
              'resolve': OutreFunctionValue(
                (final List<OutreValue> arguments) async {
                  completer.complete(arguments.first);
                  return OutreNullValue();
                },
              ),
              'fail': OutreFunctionValue(
                (final List<OutreValue> arguments) async {
                  completer.completeError(arguments.first);
                  return OutreNullValue();
                },
              ),
              'value': value,
            },
          );
        },
      ),
    },
  );
}
