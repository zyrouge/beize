import 'dart:math';

import '../../values/exports.dart';
import '../namespace.dart';

abstract class BeizeMathNatives {
  static Random random = Random();

  static void bind(final BeizeNamespace namespace) {
    final BeizeObjectValue value = BeizeObjectValue();
    value.set(
      BeizeStringValue('random'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double value = random.nextDouble();
          return BeizeNumberValue(value);
        },
      ),
    );
    value.set(
      BeizeStringValue('pi'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) => BeizeNumberValue(pi),
      ),
    );
    value.set(
      BeizeStringValue('sin'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(sin(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('cos'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(cos(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('tan'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(tan(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('asin'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(asin(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('acos'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(acos(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('atan'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(atan(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('atan2'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          final double b = call.argumentAt<BeizeNumberValue>(1).value;
          return BeizeNumberValue(atan2(a, b));
        },
      ),
    );
    value.set(
      BeizeStringValue('exp'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(exp(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('log'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(log(a));
        },
      ),
    );
    value.set(
      BeizeStringValue('min'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          final double b = call.argumentAt<BeizeNumberValue>(1).value;
          return BeizeNumberValue(min(a, b));
        },
      ),
    );
    value.set(
      BeizeStringValue('max'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          final double b = call.argumentAt<BeizeNumberValue>(1).value;
          return BeizeNumberValue(max(a, b));
        },
      ),
    );
    value.set(
      BeizeStringValue('pow'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          final double b = call.argumentAt<BeizeNumberValue>(1).value;
          return BeizeNumberValue(pow(a, b).toDouble());
        },
      ),
    );
    value.set(
      BeizeStringValue('sqrt'),
      BeizeNativeFunctionValue.sync(
        (final BeizeNativeFunctionCall call) {
          final double a = call.argumentAt<BeizeNumberValue>(0).value;
          return BeizeNumberValue(sqrt(a));
        },
      ),
    );
    namespace.declare('Math', value);
  }
}
