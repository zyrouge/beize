import 'dart:async';
import '../../ast/exports.dart';

abstract class OutreGlobalPromiseValue {
  static const String name = 'promise';

  static OutreObjectValue get value => OutreObjectValue(
        <OutreValuePropertyKey, OutreValue>{
          'create': OutreFunctionValue(
            (final _) async {
              final Completer<OutreValue> completer = Completer<OutreValue>();
              final OutrePromiseValue value =
                  OutrePromiseValue(completer.future);
              return OutreObjectValue(
                <OutreValuePropertyKey, OutreValue>{
                  'resolve': OutreFunctionValue(
                    (final OutreFunctionValueCall call) async {
                      completer.complete(call.argAt(0));
                      return OutreNullValue();
                    },
                  ),
                  'fail': OutreFunctionValue(
                    (final OutreFunctionValueCall call) async {
                      completer.completeError(call.argAt(0));
                      return OutreNullValue();
                    },
                  ),
                  'value': value,
                },
              );
            },
          ),
          'awaitAll': OutreFunctionValue(
            (final OutreFunctionValueCall call) async {
              final OutreArrayValue promises = call.argAt(0).cast();
              return OutreArrayValue(
                await Future.wait(
                  promises.values.map(
                    (final OutreValue x) {
                      if (x is OutrePromiseValue) return x.resolve();
                      return Future<OutreValue>.value(x);
                    },
                  ).toList(),
                ),
              );
            },
          ),
        },
      );
}
