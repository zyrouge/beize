import '../vm/exports.dart';
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

        case 'replaceFirstMapped':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiStringValue result = await replaceMapped(call, 1);
              return result;
            },
          );

        case 'replaceAllMapped':
          return FubukiNativeFunctionValue.async(
            (final FubukiNativeFunctionCall call) async {
              final FubukiStringValue result = await replaceMapped(call);
              return result;
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

        case 'format':
          return FubukiNativeFunctionValue.sync(
            (final FubukiNativeFunctionCall call) {
              final FubukiPrimitiveObjectValue value = call.argumentAt(0);
              return FubukiStringValue(format(value));
            },
          );

        default:
      }
    }
    return super.get(key);
  }

  Future<FubukiStringValue> replaceMapped(
    final FubukiNativeFunctionCall call, [
    final int? count,
  ]) async {
    final FubukiStringValue pattern = call.argumentAt(0);
    final FubukiFunctionValue mapper = call.argumentAt(1);
    final String result = await replacePatternMapped(
      pattern.value,
      (final Match match) async {
        final FubukiValue result = await mapper.callInVM(
          call.vm,
          <FubukiValue>[FubukiStringValue(match.group(0)!)],
        ).unwrapUnsafe();
        return result.cast<FubukiStringValue>().value;
      },
      count: count,
    );
    return FubukiStringValue(result);
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

  String format(final FubukiPrimitiveObjectValue env) {
    if (env is FubukiListValue) {
      int i = 0;
      return value.replaceAllMapped(
        RegExp(r'(?<!\\){([^}]*)}'),
        (final Match match) {
          final String key = match[1]!;
          if (key.isEmpty) {
            return env.getIndex(++i).kToString();
          }
          return env.getIndex(int.parse(key)).kToString();
        },
      );
    }
    final String result = value.replaceAllMapped(
      RegExp(r'(?<!\\){([^}]+)}'),
      (final Match match) {
        final String key = match[1]!;
        return env.get(FubukiStringValue(key)).kToString();
      },
    );
    return result;
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
