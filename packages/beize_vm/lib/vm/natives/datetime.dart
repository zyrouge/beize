import '../../values/exports.dart';
import '../exports.dart';

class BeizeDateTimeValue extends BeizePrimitiveObjectValue {
  BeizeDateTimeValue(this.value);

  final DateTime value;

  @override
  final String kName = 'BytesList';

  @override
  BeizeValue getAlongFrame(final BeizeCallFrame frame, final BeizeValue key) {
    if (key is BeizeStringValue) {
      switch (key.value) {
        case 'day':
          return BeizeNumberValue(value.day.toDouble());

        case 'weekday':
          return BeizeNumberValue(value.weekday.toDouble());

        case 'month':
          return BeizeNumberValue(value.month.toDouble());

        case 'year':
          return BeizeNumberValue(value.year.toDouble());

        case 'hour':
          return BeizeNumberValue(value.hour.toDouble());

        case 'minute':
          return BeizeNumberValue(value.minute.toDouble());

        case 'second':
          return BeizeNumberValue(value.second.toDouble());

        case 'millisecond':
          return BeizeNumberValue(value.millisecond.toDouble());

        case 'millisecondsSinceEpoch':
          return BeizeNumberValue(value.millisecondsSinceEpoch.toDouble());

        case 'timeZoneName':
          return BeizeStringValue(value.timeZoneName);

        case 'timeZoneOffset':
          return BeizeNumberValue(
            value.timeZoneOffset.inMilliseconds.toDouble(),
          );

        case 'iso':
          return BeizeStringValue(value.toIso8601String());
      }
    }
    return super.get(key);
  }

  @override
  BeizeDateTimeClassValue kClass(final BeizeCallFrame frame) =>
      frame.vm.natives.globals.dateTimeClass;

  @override
  BeizeDateTimeValue kClone() => BeizeDateTimeValue(value);

  @override
  String kToString() => value.toIso8601String();

  @override
  bool get isTruthy => true;

  @override
  int get kHashCode => value.hashCode;
}
