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

### `isFinite`

Is the number finite?

```title="Signature"
-> : Boolean
```

### `isInfinite`

Is the number infinite?

```title="Signature"
-> : Boolean
```

### `isNaN`

Is the number `NaN`?

```title="Signature"
-> : Boolean
```

### `isNegative`

Is the number negative?

```title="Signature"
-> : Boolean
```

### `abs`

Returns the number without sign.

```title="Signature"
-> : Number
```

### `ceil`

Returns the number rounded towards positive infinity.

```title="Signature"
-> : Number
```

### `round`

Returns the number rounded towards negative infinity.

```title="Signature"
-> : Number
```

### `truncate`

Returns the number discarding fractional digits.

```title="Signature"
-> : Number
```

### `precisionString`

Returns the number string with specified precision.

```title="Signature"
-> Number digits : String
```

### `toRadixString`

Returns the radix equivalent of the number.

```title="Signature"
-> Number radix : String
```
