# Match Statement

Match statements can be used to match values against the case values. Each case takes in an expression that evaluates to a value, and is executed if they are equal. The `else` case is invoked if none matches. Atmost one case is executed.

```title="Syntax"
match (expr) {
    expr1: statement1
    expr2: statement2
    ...
    exprN: statementN
    else: elseStatement
}
```

```title="Example"
a := 0
match (a) {
    -1: {
        print "Found: -1";
    }
    0: print "Found: 0";
    1: print "Found: 1";
    else: print a;
}
# Found: 0
```
