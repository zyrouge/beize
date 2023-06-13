# String

Represents a string value. Strings can be prefixed with `r` to parse them as they are. Strings are always multi-line.

```title="Syntax (RegExp)"
'[\S\s]*'
"[\S\s]*"
r'[\S\s]*'
r"[\S\s]*"
```

```title="Example"
'Hello'
"Hello"
r'This is a raw string'
r"This is a raw string"
'Supports escape sequences like \t \n'
"but also unicodes like \u0041 and \x41"

'Easy
and
peasy'
```

## Properties

### `isEmpty`

Is string empty?

```title="Signature"
-> : Boolean
```

### `isNotEmpty`

Is string not empty?

```title="Signature"
-> : Boolean
```

### `length`

Length of the string.

```title="Signature"
-> : Number
```

### `compareTo`

Compare to another string. Returns `0` if equal.

```title="Signature"
-> String other : Number
```

### `contains`

Check if `other` is present in the string.

```title="Signature"
-> String other : Boolean
```

### `startsWith`

Check if the string is prefixed with `other`.

```title="Signature"
-> String other : Boolean
```

### `endsWith`

Check if the string is suffixed with `other`.

```title="Signature"
-> String other : Boolean
```

### `indexOf`

Position of `substring` in the string. Returns `-1` if not present.

```title="Signature"
-> String substring : Number
```

### `substring`

Returns a substring between `start` and `end`.

```title="Signature"
-> Number start, Number end : String
```

### `replaceFirst`

Replaces first `substring` with `with`.

```title="Signature"
-> String pattern, String with : String
```

### `replaceAll`

Replaces all `substring` with `with`.

```title="Signature"
-> String pattern, String with : String
```

### `replaceFirstMapped`

Replaces first `substring` with value returned by `with`.

```title="Signature"
-> (pattern: String, mapper: (String) : String) => String
```

### `replaceAllMapped`

Replaces all `substring` with value returned by `with`.

```title="Signature"
-> (pattern: String, mapper: (String) : String) => String
```

### `trim`

Removes all whitespaces at the ends.

```title="Signature"
-> : String
```

### `trimLeft`

Removes all whitespaces at the start.

```title="Signature"
-> : String
```

### `trimRight`

Removes all whitespaces at the end.

```title="Signature"
-> : String
```

### `padLeft`

Pads using `with` at the start.

```title="Signature"
-> Number length, String with : String
```

### `padRight`

Pads using `with` at the end.

```title="Signature"
-> Number length, String with : String
```

### `split`

Splits the string at `splitter`s.

```title="Signature"
-> String splitter : List<String>
```

### `charAt`

Returns character at `index`.

```title="Signature"
-> Number index : String
```

### `codeUnitAt`

Returns code-unit at `index`.

```title="Signature"
-> Number index : String
```

### `toCodeUnits`

Returns code-units of the string.

```title="Signature"
-> : List<Number>
```

### `toLowerCase`

Returns the string in lowercase.

```title="Signature"
-> : String
```

### `toUpperCase`

Returns the string in uppercase.

```title="Signature"
-> : String
```

### `format`

Returns the formatted string. Example: `"{} {1}".format(["Hello", "World"])`, `"{hello} {world}".format({ hello: "Hello", world: "World" })` returns `Hello World`

```title="Signature"
-> (env: Object | List<Any>) : String
```
