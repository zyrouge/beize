# Exception

## `Exception.new`

Takes in a message, optional stack trace and returns a `ExceptionInst`.

```
exception1 := Exception.new("Something went wrong!");
exception2 := Exception.new("Something went wrong!", "at line 1");

# prints:
#   Exception: Something went wrong!
#   Stack Trace:
#   ...
print exception1;

# prints:
#   Exception: Something went wrong!
#   Stack Trace:
#   at line 1
print exception2;
```

## `ExceptionInst` (Private)

Contains information about an exception.

### `message`

Message of the exception.

```title="Signature"
String
```

```title="Example"
exception := Exception.new("Something went wrong!");

# prints "Something went wrong!"
print exception.message;
```

### `stackTrace`

Stack trace of the exception.

```title="Signature"
String
```

```title="Example"
exception := Exception.new("Something went wrong!", "at line 1");

# prints "at line 1"
print exception.stackTrace;
```
