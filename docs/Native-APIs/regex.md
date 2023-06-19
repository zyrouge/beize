# RegExp

## `RegExp.new`

Takes in a regular expression, optional flags and returns `RegExpInst`.

```title="Signature"
-> String regex, (String | Null) flags : RegExpInst
```

```title="Example"
regex1 := RegExp.new(r"\w+");
regex2 := RegExp.new("\\d+");

# prints "\\w+"
print(regex1.pattern);

# prints "\\d+"
print(regex2.pattern);
```

## `RegExpInst` (Private)

The regular expression.

### `isCaseInsensitive`

Is case insensitive flag enabled?

```title="Signature"
Boolean
```

```title="Example"
regex := RegExp.new(r"\w+", "i");

# prints true
print(regex.isCaseInsensitive);
```

### `isDotAll`

Is dot-all flag enabled?

```title="Signature"
Boolean
```

```title="Example"
regex := RegExp.new(r"\w+", "s");

# prints true
print(regex.isDotAll);
```

### `isMultiline`

Is multiline flag enabled?

```title="Signature"
Boolean
```

```title="Example"
regex := RegExp.new(r"\w+", "m");

# prints true
print(regex.isMultiline);
```

### `isUnicode`

Is unicode flag enabled?

```title="Signature"
Boolean
```

```title="Example"
regex := RegExp.new(r"\w+", "u");

# prints true
print(regex.isUnicode);
```

### `pattern`

Regular expression pattern.

```title="Signature"
String
```

```title="Example"
regex := RegExp.new(r"\w+");

# prints "\\w+"
print(regex.pattern);
```

### `hasMatch`

Does `input` has matches against the pattern.

```title="Signature"
-> String input : Boolean
```

```title="Example"
regex := RegExp.new(r"\w+");

# prints true
print(regex.hasMatch("Hello"));
```

### `stringMatch`

Returns the string match of `input` against the pattern.

```title="Signature"
-> String input : (String | Null)
```

```title="Example"
regex := RegExp.new(r"\w+");

# prints "Hello"
print(regex.stringMatch("Hello"));
```

### `firstMatch`

Returns the match of `input` against the pattern.

```title="Signature"
-> String input : (RegExpMatch | Null)
```

```title="Example"
regex := RegExp.new(r"(\d+)");

# prints "1"
print(regex.firstMatch("1 2 3").group(1));
```

### `allMatches`

Returns the all the matches of `input` against the pattern.

```title="Signature"
-> String input : List<RegExpMatch>
```

```title="Example"
regex := RegExp.new(r"(\d+)");
matches := regex.allMatches("1 2 3");

# prints,
#   "1"
#   "2"
#   "3"
matches.forEach(-> x : print(x.group(1)));
```

### `replaceFirst`

Returns a string after replacing first match of `input` against the pattern using `with`.

```title="Signature"
-> String input, String with : String
```

```title="Example"
regex := RegExp.new(r"\.md$");

# prints "index.html"
print(regex.replaceFirst("index.md", ".html"));
```

### `replaceAll`

Returns a string after replacing all the matches of `input` against the pattern using `with`.

```title="Signature"
-> String input, String with : String
```

```title="Example"
regex := RegExp.new(r"\.md");

# prints "index.html, hello.html"
print(regex.replaceAll("index.md, hello.md", ".html"));
```

### `replaceFirstMapped`

Returns a string after replacing first match of `input` against the pattern using the value returned by `with`.

```title="Signature"
-> String input, (-> RegExpMatch : String) with : String
```

```title="Example"
regex := RegExp.new(r"[A-Z]+");

# prints "hello worLD"
print(regex.replaceFirstMapped("HELLo worLD", -> match : match.group(0).toLowerCase()));
```

### `replaceAllMapped`

Returns a string after replacing all the matches of `input` against the pattern using the value returned by `with`.

```title="Signature"
-> String input, (-> RegExpMatch : String) with : String
```

```title="Example"
regex := RegExp.new(r"[A-Z]+");

# prints "hello world"
print(regex.replaceAllMapped("HELLo worLD", -> match : match.group(0).toLowerCase()));
```

## `RegExpMatch` (Private)

Contains information about a regular expression match.

### `input`

The input.

```title="Signature"
String
```

```title="Example"
regex := RegExp.new(r"(\d+)");
match := regex.firstMatch("1 2 3");

# prints "1 2 3"
print(match.input);
```

### `groupCount`

The number of groups.

```title="Signature"
Number
```

```title="Example"
regex := RegExp.new(r"(\d+)");
match := regex.firstMatch("1 2 3");

# prints 1
print(match.groupCount);
```

### `groupNames`

The names of the groups.

```title="Signature"
List<String>
```

```title="Example"
regex := RegExp.new(r"(?<digit>\d+)");
match := regex.firstMatch("1 2 3");

# prints ["digit"]
print(match.groupNames);
```

### `namedGroup`

Returns the match using the `groupName`.

```title="Signature"
-> String groupName : (RegExpMatch | Null)
```

```title="Example"
regex := RegExp.new(r"(?<digit>\d+)");
match := regex.firstMatch("1 2 3");

# prints "1"
print(match.namedGroup("digit"));
```

### `group`

Returns the match at the `index`.

```title="Signature"
-> Number index : (RegExpMatch | Null)
```

```title="Example"
regex := RegExp.new(r"(\d+)");
match := regex.firstMatch("1 2 3");

# prints "1"
print(match.group(1));
```
