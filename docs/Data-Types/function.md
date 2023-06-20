# Function

Represents a callable object. Functions are prefixed with right arrow operator (`->`). They are anonymous and cannot have a named unlike other programming languages. They are invoked using call operator. They can take in parameters and may return values.

Functions can marked as `async` to allow usage of `.await`. These functions always return a `unawaited` value. The async function is not executed until `.await` is invoked.

```title="Syntax"
-> [async] [param1, param2, ..., paramN] {
    statements
}

-> [async] [param1, param2, ..., paramN] : expr
```

```title="Example"
-> { return 1; }
-> a, b { return a + b; }

-> a, b : a + b
-> x : x

-> async { return 1; }
-> async a, b { return a + b; }

-> async a, b : a + b
-> async x : x
```

## Properties

### `call`

Calls the function and returns the result.

```title="Signature"
-> List<Any> params : Any
```

```title="Signature (Async Function)"
-> List<Any> params : Unawaited<Any>
```

```title="Example"
printHello := -> value {
    print(value);
};

printHelloAsync := -> async value {
    print(value);
};

# prints "Hello World!"
printHello.call(["Hello World!"]);

# prints "Hello World!"
printHelloAsync.call(["Hello World!"]).await;
```
