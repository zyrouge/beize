# For Statement

For statement has three main parts, the initialization, the condition and the increment or decrement. It executes the set of code until the condition goes falsey. `break` and `continue` statement can be used inside a `for` loop.

```title="Syntax"
for ([initialization]; [condition]; [increment/decrement]) {
    statement
}
```

```title="Example"
for (i := 0; i < 5; i++) {
    print(i);
}
# prints,
#   0
#   1
#   2
#   3
#   4

for (;;) {
    print("Hello!");
}
# prints "Hello!" infinitely
```
