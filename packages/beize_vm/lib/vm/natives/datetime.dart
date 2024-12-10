import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeDateTimeNatives {
  static void bind(final BeizeNamespace namespace) {
    final BeizeMapValue value = BeizeMapValue();
    value.set(
      BeizeStringValue('fromMillisecondsSinceEpoch'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeNumberValue ms = call.argumentAt(0);
          return newDateTimeInst(
            DateTime.fromMillisecondsSinceEpoch(ms.intValue),
          );
        },
      ),
    );
    value.set(
      BeizeStringValue('parse'),
      BeizeNativeFunctionValue.sync(
        (final BeizeCallableCall call) {
          final BeizeStringValue value = call.argumentAt(0);
          return newDateTimeInst(DateTime.parse(value.value));
        },
      ),
    );
    value.set(
      BeizeStringValue('now'),
      BeizeNativeFunctionValue.sync(
        (final _) => newDateTimeInst(DateTime.now()),
      ),
    );
    namespace.declare('DateTime', value);
  }

  static BeizeMapValue newDateTimeInst(final DateTime dateTime) {
    final BeizeMapValue value = BeizeMapValue();
    value.set(
      BeizeStringValue('day'),
      BeizeNumberValue(dateTime.day.toDouble()),
    );
    value.set(
      BeizeStringValue('weekday'),
      BeizeNumberValue(dateTime.weekday.toDouble()),
    );
    value.set(
      BeizeStringValue('month'),
      BeizeNumberValue(dateTime.month.toDouble()),
    );
    value.set(
      BeizeStringValue('year'),
      BeizeNumberValue(dateTime.year.toDouble()),
    );
    value.set(
      BeizeStringValue('hour'),
      BeizeNumberValue(dateTime.hour.toDouble()),
    );
    value.set(
      BeizeStringValue('minute'),
      BeizeNumberValue(dateTime.minute.toDouble()),
    );
    value.set(
      BeizeStringValue('second'),
      BeizeNumberValue(dateTime.second.toDouble()),
    );
    value.set(
      BeizeStringValue('millisecond'),
      BeizeNumberValue(dateTime.millisecond.toDouble()),
    );
    value.set(
      BeizeStringValue('millisecondsSinceEpoch'),
      BeizeNumberValue(dateTime.millisecondsSinceEpoch.toDouble()),
    );
    value.set(
      BeizeStringValue('timeZoneName'),
      BeizeStringValue(dateTime.timeZoneName),
    );
    value.set(
      BeizeStringValue('timeZoneOffset'),
      BeizeNumberValue(dateTime.timeZoneOffset.inMilliseconds.toDouble()),
    );
    value.set(
      BeizeStringValue('iso'),
      BeizeStringValue(dateTime.toIso8601String()),
    );
    return value;
  }
}
