# When Statement

When statements can be used as an alternative to `if-else` ladder. Each case takes in an conditional expression, and is executed if they are truthy. The `else` case is invoked if none evaluates to a truthy value. Atmost one case is executed.

```title="Syntax"
when {
    expr1: statement1
    expr2: statement2
    ...
    exprN: statementN
    else: elseStatement
}
```

```title="Example"
a := 2
b := 3
when {
    a > b: {
        print "Yes";
    }
    else: print "No";
}
# No
```
