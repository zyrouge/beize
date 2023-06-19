# Number

## `Number.infinity`

Returns infinity.

```title="Signature"
Number
```

```title="Example"
# prints Infinity
print(Number.infinity);
```

## `Number.negativeInfinity`

Returns negative infinity.

```title="Signature"
Number
```

```title="Example"
# prints -Infinity
print(Number.negativeInfinity);
```

## `Number.NaN`

Returns `NaN`.

```title="Signature"
Number
```

```title="Example"
# prints NaN
print(Number.NaN);
```

## `Number.maxFinite`

Returns the maximum value of number.

```title="Signature"
Number
```

```title="Example"
# prints 1.7976931348623157e+308
print(Number.maxFinite);
```

## `Number.from`

Takes in a value and returns a number.

```title="Signature"
-> Any value : Number
```

```title="Example"
# prints 10
print(Number.from("10"));
```

## `Number.fromOrNull`

Takes in a value and returns a number or `null`.

```title="Signature"
-> Any value : (Number | Null)
```

```title="Example"
# prints 10
print(Number.from("10"));

# prints null
print(Number.from([]));
```

## `Number.fromRadix`

Takes in a value and returns a number.

```title="Signature"
-> String value, Number radix : Number
```

```title="Example"
# prints 55
print(Number.fromRadix("110111", 2));

# prints 15
print(Number.fromRadix("17", 8));
```

## `Number.fromRadixOrNull`

Takes in a value and returns a number or `null`.

```title="Signature"
-> String value, Number radix : (Number | Null)
```

```title="Example"
# prints 55
print(Number.fromRadixOrNull("110111"));

# prints null
print(Number.fromRadixOrNull([]));
```
