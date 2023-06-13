# Nullable OR

Nullable OR operator (`??`) can be used to return a alternative value when the primary value is `null`, i.e. returns right-hand side value if left-hand side value is `null`.

```title="Syntax"
expr1 ?? expr2
```

```title="Example"
a ?? b

null ?? 2
# 2

1 ?? 2
# 1
```
