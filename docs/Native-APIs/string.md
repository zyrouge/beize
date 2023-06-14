# String

## `String.from`

Takes in a value and returns a string.

```title="Signature"
-> Any value : String
```

```title="Example"
# prints "false"
print String.from(false);

# prints "1"
print String.from(1);

# prints "[1, 2, 3]"
print String.from([1, 2, 3]);
```

## `String.fromCodeUnit`

Takes in a byte and returns the equivalent character value as string.

```title="Signature"
-> Number codeUnit : String
```

```title="Example"
# prints "H"
print String.fromCodeUnit(72);
```

## `String.fromCodeUnits`

Takes in a byte and returns the equivalent character value as string.

```title="Signature"
-> List<Number> codeUnits : String
```

```title="Example"
# prints "Hello"
print String.fromCodeUnit([72, 101, 108, 108, 111]);
```
