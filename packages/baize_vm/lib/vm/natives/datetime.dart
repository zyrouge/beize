import '../../values/exports.dart';
import '../namespace.dart';

abstract class BaizeDateTimeNatives {
  static void bind(final BaizeNamespace namespace) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('fromMillisecondsSinceEpoch'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeNumberValue ms = call.argumentAt(0);
          return newDateTimeInst(
            DateTime.fromMillisecondsSinceEpoch(ms.intValue),
          );
        },
      ),
    );
    value.set(
      BaizeStringValue('parse'),
      BaizeNativeFunctionValue.sync(
        (final BaizeNativeFunctionCall call) {
          final BaizeStringValue value = call.argumentAt(0);
          return newDateTimeInst(DateTime.parse(value.value));
        },
      ),
    );
    value.set(
      BaizeStringValue('now'),
      BaizeNativeFunctionValue.sync(
        (final _) => newDateTimeInst(DateTime.now()),
      ),
    );
    namespace.declare('DateTime', value);
  }

  static BaizeObjectValue newDateTimeInst(final DateTime dateTime) {
    final BaizeObjectValue value = BaizeObjectValue();
    value.set(
      BaizeStringValue('day'),
      BaizeNumberValue(dateTime.day.toDouble()),
    );
    value.set(
      BaizeStringValue('weekday'),
      BaizeNumberValue(dateTime.weekday.toDouble()),
    );
    value.set(
      BaizeStringValue('month'),
      BaizeNumberValue(dateTime.month.toDouble()),
    );
    value.set(
      BaizeStringValue('year'),
      BaizeNumberValue(dateTime.year.toDouble()),
    );
    value.set(
      BaizeStringValue('hour'),
      BaizeNumberValue(dateTime.hour.toDouble()),
    );
    value.set(
      BaizeStringValue('minute'),
      BaizeNumberValue(dateTime.minute.toDouble()),
    );
    value.set(
      BaizeStringValue('second'),
      BaizeNumberValue(dateTime.second.toDouble()),
    );
    value.set(
      BaizeStringValue('millisecond'),
      BaizeNumberValue(dateTime.millisecond.toDouble()),
    );
    value.set(
      BaizeStringValue('millisecondsSinceEpoch'),
      BaizeNumberValue(dateTime.millisecondsSinceEpoch.toDouble()),
    );
    value.set(
      BaizeStringValue('timeZoneName'),
      BaizeStringValue(dateTime.timeZoneName),
    );
    value.set(
      BaizeStringValue('timeZoneOffset'),
      BaizeNumberValue(dateTime.timeZoneOffset.inMilliseconds.toDouble()),
    );
    value.set(
      BaizeStringValue('iso'),
      BaizeStringValue(dateTime.toIso8601String()),
    );
    return value;
  }
}
