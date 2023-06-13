# RegExp

## Objects

### `RegExp`

The regular expression.

| Property             | Signature                                                    | Description                                                                                                         |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| `isCaseInsensitive`  | `Boolean`                                                    | Is case insensitive flag enabled?                                                                                   |
| `isDotAll`           | `Boolean`                                                    | Is dot-all flag enabled?                                                                                            |
| `isMultiline`        | `Boolean`                                                    | Is multiline flag enabled?                                                                                          |
| `isUnicode`          | `Boolean`                                                    | Is unicode flag enabled?                                                                                            |
| `pattern`            | `String`                                                     | Regular expression pattern.                                                                                         |
| `hasMatch`           | `-> String input : Boolean`                                  | Does `input` has matches against the pattern.                                                                       |
| `stringMatch`        | `-> String input : String`                                   | Returns the string match of `input` against the pattern.                                                            |
| `firstMatch`         | `-> String input : RegExpMatch?`                             | Returns the match of `input` against the pattern.                                                                   |
| `allMatches`         | `-> String input : List<RegExpMatch>`                        | Returns the all the matches of `input` against the pattern.                                                         |
| `replaceFirst`       | `-> String input, String with : String`                      | Returns a string after replacing first match of `input` against the pattern using `with`.                           |
| `replaceAll`         | `-> String input, String with : String`                      | Returns a string after replacing all the matches of `input` against the pattern using `with`.                       |
| `replaceFirstMapped` | `-> (input: String, with: (RegExpMatch) : String) => String` | Returns a string after replacing first match of `input` against the pattern using the value returned by `with`.     |
| `replaceAllMapped`   | `-> (input: String, with: (RegExpMatch) : String) => String` | Returns a string after replacing all the matches of `input` against the pattern using the value returned by `with`. |

### `RegExpMatch`

Contains information about a regular expression match.

| Property     | Signature                            | Description                              |
| ------------ | ------------------------------------ | ---------------------------------------- |
| `input`      | `String`                             | The input.                               |
| `groupCount` | `Number`                             | The number of groups.                    |
| `groupNames` | `List<String>`                       | The names of the groups.                 |
| `namedGroup` | `-> String groupName : RegExpMatch?` | Returns the match using the `groupName`. |
| `group`      | `-> Number index : RegExpMatch?`     | Returns the match at the `index`.        |

## `RegExp.new`

Takes in a value and returns the boolean equivalent.

```
RegExp.new(r"\w+");
# regexp of pattern \w+

RegExp.new("\\d+");
# regexp of pattern \d+
```
