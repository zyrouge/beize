# Number

Represents a double-precision floating point value. Supports exponents (`XeY`) and hexadecimal (`0xAAAAAAAA`) values. `NaN` is used to denote a invalid number. Infinity, negative infinity and `NaN` can be created using native number helpers.

```title="Syntax (RegExp)"
-?\d+(\.\d+)?
-?\d+(\.\d+)?e(\+|-)?\d+
-?0[Xx][A-Fa-f]+
```

```title="Example"
0
-140
-9.2
100
250.67
10e2
10e-4
0xfff
```

## Properties

### `sign`

Returns the `-1` (less than zero), `0` (zero) or `1` (greater than zero).

```title="Signature"
-> : Number
```

```title="Example"
num := -5;

# prints -1
print num.sign();
```

### `isFinite`

Is the number finite?

```title="Signature"
-> : Boolean
```

```title="Example"
num := 5;

# prints true
print num.isFinite();
```

### `isInfinite`

Is the number infinite?

```title="Signature"
-> : Boolean
```

```title="Example"
num := 5;

# prints false
print num.isInfinite();
```

### `isNaN`

Is the number `NaN`?

```title="Signature"
-> : Boolean
```

```title="Example"
num := 5;

# prints false
print num.isNaN();
```

### `isNegative`

Is the number negative?

```title="Signature"
-> : Boolean
```

```title="Example"
num := 5;

# prints false
print num.isNegative();
```

### `abs`

Returns the number without sign.

```title="Signature"
-> : Number
```

```title="Example"
num := -5;

# prints 5
print num.abs();
```

### `ceil`

Returns the number rounded towards positive infinity.

```title="Signature"
-> : Number
```

```title="Example"
num := 5.1;

# prints 6
print num.ceil();
```

### `round`

Returns the number rounded towards negative infinity.

```title="Signature"
-> : Number
```

```title="Example"
num := 5.5;

# prints 6
print num.round();
```

### `truncate`

Returns the number discarding fractional digits.

```title="Signature"
-> : Number
```

```title="Example"
num := 5.45;

# prints 5
print num.truncate();
```

### `precisionString`

Returns the number string with specified precision.

```title="Signature"
-> Number digits : String
```

```title="Example"
num := 5.2512;

# prints "5.25"
print num.precisionString(2);
```

### `toRadixString`

Returns the radix equivalent of the number.

```title="Signature"
-> Number radix : String
```

```title="Example"
num := 5;

# prints 101
print num.toRadixString(2);
```
