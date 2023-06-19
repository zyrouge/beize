# Function

## `Function.call`

Takes in an function, list of arguments and returns the result of the function after calling.

```title="Signature"
-> List<Any> params : Any
```

```title="Example"
printString := -> value {
    print(value);
};

# prints "Hello World!"
Function.call(printHello, ["Hello World!"]);
```
