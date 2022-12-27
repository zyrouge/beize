import '../../values/exports.dart';
import '../namespace.dart';

abstract class FubukiDateTimeNatives {
  static void bind(final FubukiNamespace namespace) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('fromMillisecondsSinceEpoch'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiNumberValue ms = call.argumentAt(0);
          return newDateTimeInst(
            DateTime.fromMillisecondsSinceEpoch(ms.intValue),
          );
        },
      ),
    );
    value.set(
      FubukiStringValue('parse'),
      FubukiNativeFunctionValue.sync(
        (final FubukiNativeFunctionCall call) {
          final FubukiStringValue value = call.argumentAt(0);
          return newDateTimeInst(DateTime.parse(value.value));
        },
      ),
    );
    value.set(
      FubukiStringValue('now'),
      FubukiNativeFunctionValue.sync(
        (final _) => newDateTimeInst(DateTime.now()),
      ),
    );
    namespace.declare('DateTime', value);
  }

  static FubukiObjectValue newDateTimeInst(final DateTime dateTime) {
    final FubukiObjectValue value = FubukiObjectValue();
    value.set(
      FubukiStringValue('day'),
      FubukiNumberValue(dateTime.day.toDouble()),
    );
    value.set(
      FubukiStringValue('weekday'),
      FubukiNumberValue(dateTime.weekday.toDouble()),
    );
    value.set(
      FubukiStringValue('month'),
      FubukiNumberValue(dateTime.month.toDouble()),
    );
    value.set(
      FubukiStringValue('year'),
      FubukiNumberValue(dateTime.year.toDouble()),
    );
    value.set(
      FubukiStringValue('hour'),
      FubukiNumberValue(dateTime.hour.toDouble()),
    );
    value.set(
      FubukiStringValue('minute'),
      FubukiNumberValue(dateTime.minute.toDouble()),
    );
    value.set(
      FubukiStringValue('second'),
      FubukiNumberValue(dateTime.second.toDouble()),
    );
    value.set(
      FubukiStringValue('millisecond'),
      FubukiNumberValue(dateTime.millisecond.toDouble()),
    );
    value.set(
      FubukiStringValue('millisecondsSinceEpoch'),
      FubukiNumberValue(dateTime.millisecondsSinceEpoch.toDouble()),
    );
    value.set(
      FubukiStringValue('iso'),
      FubukiStringValue(dateTime.toIso8601String()),
    );
    return value;
  }
}
