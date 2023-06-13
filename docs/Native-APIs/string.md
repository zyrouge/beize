# String

## `String.from`

Takes in a value and returns a string.

```
String.from(false);
# "false"

String.from(1);
# "1"

String.from([1, 2, 3]);
# "[1, 2, 3]"
```

## `String.fromCodeUnit`

Takes in a byte and returns the equivalent character value as string.

```
String.fromCodeUnit(72);
# H
```

## `String.fromCodeUnits`

Takes in a byte and returns the equivalent character value as string.

```
String.fromCodeUnit([72, 101, 108, 108, 111]);
# Hello
```
