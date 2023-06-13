# Function

Represents a callable object. Functions are prefixed with right arrow operator (`->`). They are anonymous and cannot have a named unlike other programming languages. They are invoked using call operator. They can take in parameters and may return values.

```title="Syntax"
-> [param1, param2, ..., paramN] {
    statements
}

-> [param1, param2, ..., paramN] : expr
```

```title="Example"
-> { return 1; }
-> a, b { return a + b; }

-> a, b : a + b
-> x : x
```

## Properties

### `call`

Calls the function and returns the result.

```title="Signature"
-> List<Any> params, Number index : Any
```
