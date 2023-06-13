# Object

Represents a pair of keys and values. Objects are not created from classes since classes do not even exist. The keys are parsed as identifiers and values are parsed as expressions. Any keys using surrounding brackets (`[]`) are parsed as expressions. They properties can be accessed using the get and set operators.

```title="Syntax"
{
    [property: expr,]
    ...
    [\[expr\]: expr,]
    ...
}
```

```title="Example"
{}

{
    hello1: "world1",
    ["hello2"]: "world2",
    [1]: "world3",
}
```
