# This

This operator (`this`) points to the enclosed object scope.

```title="Syntax"
this
```

```title="Example"
obj := {
    value: "Hello World",
    printValue: -> {
        print(this.value);
    },
};

# prints "Hello World"
obj.printValue();
```
