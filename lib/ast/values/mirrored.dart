import 'exports.dart';

typedef OutreMirroredValueGetFn = OutreValue? Function(
  OutreValuePropertyKey key,
);

typedef OutreMirroredValueSetFn = void Function(
  OutreValuePropertyKey key,
  OutreValue value,
);

class OutreMirroredValue extends OutreValue {
  OutreMirroredValue({
    required this.get,
    required this.set,
  }) : super(OutreValues.interalMirroredValue);

  factory OutreMirroredValue.fromOutreValue(final OutreValue value) =>
      OutreMirroredValue(
        get: (final OutreValuePropertyKey key) => value.getPropertyOfKey(key),
        set: (final OutreValuePropertyKey key, final OutreValue value) {
          value.setPropertyOfKey(key, value);
        },
      );

  final OutreMirroredValueGetFn get;
  final OutreMirroredValueSetFn set;

  @override
  void setPropertyOfKey(
    final OutreValuePropertyKey key,
    final OutreValue value,
  ) {
    set(key, value);
  }

  @override
  OutreValue getPropertyOfKey(final OutreValuePropertyKey key) =>
      get(key) ?? getDefaultPropertyOfKey(key);
}
