import '../../vm/exports.dart';
import '../exports.dart';

class BeizeMapValue extends BeizeNativeObjectValue {
  BeizeMapValue([final Map<int, List<BeizeValuePair>>? fields])
      : super(fields: fields);

  @override
  final BeizeValueKind kind = BeizeValueKind.object;

  @override
  BeizeMapValue kClone() =>
      BeizeMapValue(Map<int, List<BeizeValuePair>>.of(fields));

  @override
  String kToString() {
    final List<String> stringValues = <String>[];
    for (final List<BeizeValuePair> x in fields.values) {
      for (final BeizeValuePair y in x) {
        final String key = y.key.kToString();
        final String value = y.value.kToString();
        stringValues.add('$key: $value');
      }
    }
    return '{${stringValues.join(', ')}}';
  }

  @override
  BeizeClassValue kClassInternal(final BeizeVM vm) => vm.globals.mapClass;

  @override
  BeizeClassValue get kClass => throw UnimplementedError();

  @override
  bool get isTruthy => fields.isNotEmpty;

  @override
  int get kHashCode => fields.hashCode;
}
