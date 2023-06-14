# While Statement

While statement allows repeating a set of code until the condition goes falsey. `break` and `continue` statement can be used inside a `while` loop.

```title="Syntax"
while (condition) {
    statement
}
```

```title="Example"
i := 0;
while (i < 5) {
    print i;
    i = i + 1;
}
# 0 1 2 3 4
```
