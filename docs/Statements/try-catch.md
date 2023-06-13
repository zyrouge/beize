# Try-Catch Statement

Try-catch statement is used to handle exceptions and unintended behaviours. Try-catch consists a `try` block that might throw exceptions and `catch` block that handles the exception.

```title="Syntax"
try {
    tryStatements
} catch (exception) {
    catchStatements
}
```

```title="Example"
try {
    throw "Hello World!";
} catch (err) {
    print err;
}
# Hello World!
```
