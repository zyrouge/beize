# Continue Statement

Continue statement can be used to skip current iteration. This is done using the `continue` keyword.

```title="Syntax"
continue;
```

```title="Example"
i := 0;
while (i < 6) {
    i = i + 1;
    if (i % 2 == 0) continue;
    print i;
}
# 1 3 5
```
