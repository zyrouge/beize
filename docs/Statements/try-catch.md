# Try-Catch Statement

Try-catch statement is used to handle exceptions and unintended behaviours. Try-catch consists a `try` block that might throw exceptions and `catch` block that handles the exception.

```title="Syntax"
try {
    tryStatement
} catch (exception) {
    catchStatement
}
```

```title="Example"
try {
    throw "Hello World!";
} catch (err) {
    print(err);
}

# prints "Hello World!"
```
