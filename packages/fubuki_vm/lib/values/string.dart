import 'exports.dart';

class FubukiStringValue extends FubukiPrimitiveObjectValue {
  FubukiStringValue(this.value);

  final String value;

  @override
  FubukiValue get(final FubukiValue key) {
    if (key is FubukiStringValue) {
      switch (key.value) {
        case 'isEmpty':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(value.isEmpty),
          );

        case 'isNotEmpty':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiBooleanValue(value.isNotEmpty),
          );

        case 'length':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiNumberValue(value.length.toDouble()),
          );

        case 'compareTo':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue other = call.argumentAt(0);
              return FubukiNumberValue(
                value.compareTo(other.value).toDouble(),
              );
            },
          );

        case 'contains':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue other = call.argumentAt(0);
              return FubukiBooleanValue(value.contains(other.value));
            },
          );

        case 'startsWith':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue other = call.argumentAt(0);
              return FubukiBooleanValue(value.startsWith(other.value));
            },
          );

        case 'endsWith':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue other = call.argumentAt(0);
              return FubukiBooleanValue(value.endsWith(other.value));
            },
          );

        case 'indexOf':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue other = call.argumentAt(0);
              return FubukiNumberValue(
                value.indexOf(other.value).toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue other = call.argumentAt(0);
              return FubukiNumberValue(
                value.lastIndexOf(other.value).toDouble(),
              );
            },
          );

        case 'substring':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiNumberValue start = call.argumentAt(0);
              final FubukiNumberValue end = call.argumentAt(1);
              return FubukiStringValue(
                value.substring(start.intValue, end.intValue),
              );
            },
          );

        case 'replaceFirst':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue from = call.argumentAt(0);
              final FubukiStringValue to = call.argumentAt(1);
              return FubukiStringValue(
                value.replaceFirst(from.value, to.value),
              );
            },
          );

        case 'replaceAll':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiStringValue from = call.argumentAt(0);
              final FubukiStringValue to = call.argumentAt(1);
              return FubukiStringValue(
                value.replaceAll(from.value, to.value),
              );
            },
          );

        case 'trim':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(value.trim()),
          );

        case 'trimLeft':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(value.trimLeft()),
          );

        case 'trimRight':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(value.trimRight()),
          );

        case 'padLeft':
          return FubukiNativeFunctionValue.sync(
              (final FubukiNativeFunctionCall call) {
            final FubukiNumberValue amount = call.argumentAt(0);
            final FubukiStringValue by = call.argumentAt(1);
            return FubukiStringValue(value.padLeft(amount.intValue, by.value));
          });

        case 'padRight':
          return FubukiNativeFunctionValue.sync(
              (final FubukiNativeFunctionCall call) {
            final FubukiNumberValue amount = call.argumentAt(0);
            final FubukiStringValue by = call.argumentAt(1);
            return FubukiStringValue(value.padRight(amount.intValue, by.value));
          });

        case 'split':
          return FubukiNativeFunctionValue.sync(
              (final FubukiNativeFunctionCall call) {
            final FubukiStringValue delimiter = call.argumentAt(0);
            return FubukiListValue(
              value
                  .split(delimiter.value)
                  .map((final String x) => FubukiStringValue(x))
                  .toList(),
            );
          });

        case 'codeUnitAt':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiNumberValue index = call.argumentAt(0);
              return FubukiNumberValue(
                value.codeUnitAt(index.intValue).toDouble(),
              );
            },
          );

        case 'toCodeUnits':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiListValue(
              value.codeUnits
                  .map((final int x) => FubukiNumberValue(x.toDouble()))
                  .toList(),
            ),
          );

        case 'toLowerCase':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(value.toLowerCase()),
          );

        case 'toUpperCase':
          return FubukiNativeFunctionValue.sync(
            (final _) => FubukiStringValue(value.toUpperCase()),
          );

        default:
      }
    }
    return super.get(key);
  }

  @override
  final FubukiValueKind kind = FubukiValueKind.string;

  @override
  FubukiStringValue kClone() => FubukiStringValue(value);

  @override
  String kToString() => value;

  @override
  bool get isTruthy => value.isNotEmpty;

  @override
  int get kHashCode => value.hashCode;
}
