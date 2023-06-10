import 'exports.dart';

class BaizeStringValue extends BaizePrimitiveObjectValue {
  BaizeStringValue(this.value);

  final String value;

  @override
  BaizeValue get(final BaizeValue key) {
    if (key is BaizeStringValue) {
      switch (key.value) {
        case 'isEmpty':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(value.isEmpty),
          );

        case 'isNotEmpty':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeBooleanValue(value.isNotEmpty),
          );

        case 'length':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeNumberValue(value.length.toDouble()),
          );

        case 'compareTo':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue other = call.argumentAt(0);
              return BaizeNumberValue(
                value.compareTo(other.value).toDouble(),
              );
            },
          );

        case 'contains':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue other = call.argumentAt(0);
              return BaizeBooleanValue(value.contains(other.value));
            },
          );

        case 'startsWith':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue other = call.argumentAt(0);
              return BaizeBooleanValue(value.startsWith(other.value));
            },
          );

        case 'endsWith':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue other = call.argumentAt(0);
              return BaizeBooleanValue(value.endsWith(other.value));
            },
          );

        case 'indexOf':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue other = call.argumentAt(0);
              return BaizeNumberValue(
                value.indexOf(other.value).toDouble(),
              );
            },
          );

        case 'lastIndexOf':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue other = call.argumentAt(0);
              return BaizeNumberValue(
                value.lastIndexOf(other.value).toDouble(),
              );
            },
          );

        case 'substring':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeNumberValue start = call.argumentAt(0);
              final BaizeNumberValue end = call.argumentAt(1);
              return BaizeStringValue(
                value.substring(start.intValue, end.intValue),
              );
            },
          );

        case 'replaceFirst':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue from = call.argumentAt(0);
              final BaizeStringValue to = call.argumentAt(1);
              return BaizeStringValue(
                value.replaceFirst(from.value, to.value),
              );
            },
          );

        case 'replaceAll':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeStringValue from = call.argumentAt(0);
              final BaizeStringValue to = call.argumentAt(1);
              return BaizeStringValue(
                value.replaceAll(from.value, to.value),
              );
            },
          );

        case 'replaceFirstMapped':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeStringValue result = await replaceMapped(call, 1);
              return result;
            },
          );

        case 'replaceAllMapped':
          return BaizeNativeFunctionValue.async(
            (final BaizeNativeFunctionCall call) async {
              final BaizeStringValue result = await replaceMapped(call);
              return result;
            },
          );

        case 'trim':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeStringValue(value.trim()),
          );

        case 'trimLeft':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeStringValue(value.trimLeft()),
          );

        case 'trimRight':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeStringValue(value.trimRight()),
          );

        case 'padLeft':
          return BaizeNativeFunctionValue.sync(
              (final BaizeNativeFunctionCall call) {
            final BaizeNumberValue amount = call.argumentAt(0);
            final BaizeStringValue by = call.argumentAt(1);
            return BaizeStringValue(value.padLeft(amount.intValue, by.value));
          });

        case 'padRight':
          return BaizeNativeFunctionValue.sync(
              (final BaizeNativeFunctionCall call) {
            final BaizeNumberValue amount = call.argumentAt(0);
            final BaizeStringValue by = call.argumentAt(1);
            return BaizeStringValue(value.padRight(amount.intValue, by.value));
          });

        case 'split':
          return BaizeNativeFunctionValue.sync(
              (final BaizeNativeFunctionCall call) {
            final BaizeStringValue delimiter = call.argumentAt(0);
            return BaizeListValue(
              value
                  .split(delimiter.value)
                  .map((final String x) => BaizeStringValue(x))
                  .toList(),
            );
          });

        case 'codeUnitAt':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeNumberValue index = call.argumentAt(0);
              return BaizeNumberValue(
                value.codeUnitAt(index.intValue).toDouble(),
              );
            },
          );

        case 'charAt':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizeNumberValue index = call.argumentAt(0);
              return BaizeStringValue(value[index.intValue]);
            },
          );

        case 'toCodeUnits':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeListValue(
              value.codeUnits
                  .map((final int x) => BaizeNumberValue(x.toDouble()))
                  .toList(),
            ),
          );

        case 'toLowerCase':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeStringValue(value.toLowerCase()),
          );

        case 'toUpperCase':
          return BaizeNativeFunctionValue.sync(
            (final _) => BaizeStringValue(value.toUpperCase()),
          );

        case 'format':
          return BaizeNativeFunctionValue.sync(
            (final BaizeNativeFunctionCall call) {
              final BaizePrimitiveObjectValue value = call.argumentAt(0);
              return BaizeStringValue(format(value));
            },
          );

        default:
      }
    }
    return super.get(key);
  }

  Future<BaizeStringValue> replaceMapped(
    final BaizeNativeFunctionCall call, [
    final int? count,
  ]) async {
    final BaizeStringValue pattern = call.argumentAt(0);
    final BaizeFunctionValue mapper = call.argumentAt(1);
    final String result = await replacePatternMapped(
      pattern.value,
      (final Match match) async {
        final BaizeValue result = await call.frame.callValue(
          mapper,
          <BaizeValue>[BaizeStringValue(match.group(0)!)],
        ).unwrapUnsafe();
        return result.cast<BaizeStringValue>().value;
      },
      count: count,
    );
    return BaizeStringValue(result);
  }

  Future<String> replacePatternMapped(
    final Pattern pattern,
    final Future<String> Function(Match) mapper, {
    final int? count,
  }) async {
    String result = value;
    int adjuster = 0;
    int i = 0;
    for (final Match x in pattern.allMatches(result)) {
      if (count != null && i >= count) break;
      final String by = await mapper(x);
      final String nResult = result.replaceRange(
        x.start + adjuster,
        x.end + adjuster,
        by,
      );
      adjuster = nResult.length - result.length;
      result = nResult;
      i++;
    }
    return result;
  }

  String format(final BaizePrimitiveObjectValue env) {
    if (env is BaizeListValue) {
      int i = 0;
      return value.replaceAllMapped(
        RegExp(r'(?<!\\){([^}]*)}'),
        (final Match match) {
          final String key = match[1]!;
          if (key.isEmpty) {
            return env.getIndex(i++).kToString();
          }
          return env.getIndex(int.parse(key)).kToString();
        },
      );
    }
    final String result = value.replaceAllMapped(
      RegExp(r'(?<!\\){([^}]+)}'),
      (final Match match) {
        final String key = match[1]!;
        return env.get(BaizeStringValue(key)).kToString();
      },
    );
    return result;
  }

  @override
  final BaizeValueKind kind = BaizeValueKind.string;

  @override
  BaizeStringValue kClone() => BaizeStringValue(value);

  @override
  String kToString() => value;

  @override
  bool get isTruthy => value.isNotEmpty;

  @override
  int get kHashCode => value.hashCode;
}
