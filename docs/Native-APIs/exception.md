# Exception

## Objects

### `ExceptionInst`

Contains information about an exception.

| Property     | Signature |
| ------------ | --------- |
| `message`    | `String`  |
| `stackTrace` | `String`  |

## `Exception.new`

Takes in a message, optional stack trace and returns a `ExceptionInst`.

```
Exception.new("Something went wrong!");
# Exception: Something went wrong!
# Stack Trace:
# ...

Exception.new("Something went wrong!", "at line 1");
# Exception: Something went wrong!
# Stack Trace:
# at line 1
```
