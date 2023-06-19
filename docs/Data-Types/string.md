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

```title="Example"
str := "Hello World!";

# prints false
print(str.isEmpty());
```

### `isNotEmpty`

Is string not empty?

```title="Signature"
-> : Boolean
```

```title="Example"
str := "Hello World!";

# prints true
print(str.isNotEmpty());
```

### `length`

Length of the string.

```title="Signature"
-> : Number
```

```title="Example"
str := "Hello World!";

# prints 12
print(str.length());
```

### `compareTo`

Compare to another string. Returns `0` if equal.

```title="Signature"
-> String other : Number
```

```title="Example"
str1 := "Hello";
str2 := "World";

# prints -1
print(str1.compareTo(str2));
```

### `contains`

Check if `other` is present in the string.

```title="Signature"
-> String other : Boolean
```

```title="Example"
str := "Hello World!";

# prints true
print(str.contains("!"));
```

### `startsWith`

Check if the string is prefixed with `other`.

```title="Signature"
-> String other : Boolean
```

```title="Example"
str := "Hello World!";

# prints true
print(str.startsWith("Hell"));
```

### `endsWith`

Check if the string is suffixed with `other`.

```title="Signature"
-> String other : Boolean
```

```title="Example"
str := "Hello World!";

# prints true
print(str.endsWith("!"));
```

### `indexOf`

Position of `substring` in the string. Returns `-1` if not present.

```title="Signature"
-> String substring : Number
```

```title="Example"
str := "Hello World!";

# prints 6
print(str.indexOf("W"));
```

### `substring`

Returns a substring between `start` and `end`.

```title="Signature"
-> Number start, Number end : String
```

```title="Example"
str := "Hello World!";

# prints "World"
print(str.substring(6, 11));
```

### `replaceFirst`

Replaces first `substring` with `with`.

```title="Signature"
-> String pattern, String with : String
```

```title="Example"
str := "Hello World!";

# prints "Heelo World!"
print(str.replaceFirst("l", "e"));
```

### `replaceAll`

Replaces all `substring` with `with`.

```title="Signature"
-> String pattern, String with : String
```

```title="Example"
str := "Hello World!";

# prints "Heeeo World!"
print(str.replaceAll("l", "e"));
```

### `replaceFirstMapped`

Replaces first `substring` with value returned by `with`.

```title="Signature"
-> String pattern, (-> String : String) mapper : String
```

```title="Example"
str := "Hello World!";

# prints "Heilo World!"
print(str.replaceFirstMapped("l", -> _ : "i"));
```

### `replaceAllMapped`

Replaces all `substring` with value returned by `with`.

```title="Signature"
-> String pattern, (-> String : String) mapper : String
```

```title="Example"
str := "Hello World!";

# prints "Heiio World!"
print(str.replaceAllMapped("l", -> _ : "i"));
```

### `trim`

Removes all whitespaces at the ends.

```title="Signature"
-> : String
```

```title="Example"
str := "\tHello World!   ";

# prints "Hello World!"
print(str.trim());
```

### `trimLeft`

Removes all whitespaces at the start.

```title="Signature"
-> : String
```

```title="Example"
str := "  Hello World!  ";

# prints "Hello World  "
print(str.trimLeft());
```

### `trimRight`

Removes all whitespaces at the end.

```title="Signature"
-> : String
```

```title="Example"
str := "  Hello World!  ";

# prints "  Hello World"
print(str.trimRight());
```

### `padLeft`

Pads using `with` at the start.

```title="Signature"
-> Number length, String with : String
```

```title="Example"
str := "1";

# prints 01
print(str.padLeft(2, "0"));
```

### `padRight`

Pads using `with` at the end.

```title="Signature"
-> Number length, String with : String
```

```title="Example"
str := "1";

# prints 10
print(str.padRight(2, "0"));
```

### `split`

Splits the string at `splitter`s.

```title="Signature"
-> String splitter : List<String>
```

```title="Example"
str := "Hello!";

# prints ["He", "o!"]
print(str.split("ll"));
```

### `charAt`

Returns character at `index`.

```title="Signature"
-> Number index : String
```

```title="Example"
str := "Hello World!";

# prints "e"
print(str.charAt(1));
```

### `codeUnitAt`

Returns code-unit at `index`.

```title="Signature"
-> Number index : String
```

```title="Example"
str := "Hello World!";

# prints 101
print(str.codeUnitAt(1));
```

### `toCodeUnits`

Returns code-units of the string.

```title="Signature"
-> : List<Number>
```

```title="Example"
str := "Hello!";

# prints [72, 101, 108, 108, 111, 33]
print(str.toCodeUnits());
```

### `toLowerCase`

Returns the string in lowercase.

```title="Signature"
-> : String
```

```title="Example"
str := "Hello World!";

# prints "hello world!"
print(str.toLowerCase());
```

### `toUpperCase`

Returns the string in uppercase.

```title="Signature"
-> : String
```

```title="Example"
str := "Hello World!";

# prints "HELLO WORLD!"
print(str.toUpperCase());
```

### `format`

Returns the formatted string. Example: `"{} {1}".format(["Hello", "World"])`, `"{hello} {world}".format({ hello: "Hello", world: "World" })` returns `Hello World`

```title="Signature"
-> (Object | List<Any>) env : String
```

```title="Example"
# prints "Hello World!"
print("{} {}!".format(["Hello", "World"]));
```
