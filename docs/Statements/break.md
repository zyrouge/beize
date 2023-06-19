# Break Statement

Break statement can be used to terminate the enclosing loop. This is done using the `break` keyword.

```title="Syntax"
break;
```

```title="Example"
i := 0;
while (true) {
    print(i);
    i++;
    if (i > 2) break;
}

# prints,
#   0
#   1
#   2
```
