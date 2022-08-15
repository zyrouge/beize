import '../../ast/exports.dart';

abstract class OutreGlobalDateTimeValue {
  static const String name = 'DateTime';

  static OutreValue fromDateTime(final DateTime time) =>
      OutreObjectValue(<OutreValuePropertyKey, OutreValue>{
        'millisecond': OutreNumberValue(time.millisecond.toDouble()),
        'second': OutreNumberValue(time.second.toDouble()),
        'minute': OutreNumberValue(time.minute.toDouble()),
        'hour': OutreNumberValue(time.hour.toDouble()),
        'day': OutreNumberValue(time.day.toDouble()),
        'weekday': OutreNumberValue(time.weekday.toDouble()),
        'month': OutreNumberValue(time.month.toDouble()),
        'year': OutreNumberValue(time.year.toDouble()),
        'asMilliseconds':
            OutreNumberValue(time.millisecondsSinceEpoch.toDouble())
                .asOutreFunctionValue(),
        'toISOString':
            OutreStringValue(time.toIso8601String()).asOutreFunctionValue(),
      });

  static OutreObjectValue get value => OutreObjectValue(
        <OutreValuePropertyKey, OutreValue>{
          'create': OutreFunctionValue(
            (final OutreFunctionValueCall call) async {
              final OutreObjectValue value = call.argAt(0).cast();
              return fromDateTime(
                DateTime(
                  parseAsInt(value.getPropertyOfKey('year')),
                  parseAsInt(value.getPropertyOfKey('month'), 1),
                  parseAsInt(value.getPropertyOfKey('day'), 1),
                  parseAsInt(value.getPropertyOfKey('hour'), 1),
                  parseAsInt(value.getPropertyOfKey('minute'), 1),
                  parseAsInt(value.getPropertyOfKey('second'), 1),
                  parseAsInt(value.getPropertyOfKey('millisecond'), 1),
                ),
              );
            },
          ),
          'fromISOString': OutreFunctionValue(
            (final OutreFunctionValueCall call) async => fromDateTime(
              DateTime.parse(
                call.argAt(0).cast<OutreStringValue>().value,
              ),
            ),
          ),
          'fromMilliseconds': OutreFunctionValue(
            (final OutreFunctionValueCall call) async => fromDateTime(
              DateTime.fromMillisecondsSinceEpoch(
                call.argAt(0).cast<OutreNumberValue>().value.toInt(),
              ),
            ),
          ),
          'now': OutreFunctionValue(
            (final _) async => fromDateTime(DateTime.now()),
          ),
        },
      );

  static int parseAsInt(final OutreValue value, [final int? fallback]) {
    if (fallback != null && value is OutreNullValue) {
      return fallback;
    }
    return value.cast<OutreNumberValue>().value.toInt();
  }
}
