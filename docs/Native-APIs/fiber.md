# Fiber

Fiber allows concurrent execution of code.

## `Fiber.wait`

Takes in duration in milliseconds and returns a future that resolved after the duration.

```title="Signature"
-> Number ms : Null
```

```title="Example"
# before 1 second
Future.wait(1000);
# after 1 second
```

## `Fiber.runConcurrently`

Takes in a list of functions that returns the list of values returned.

```title="Signature"
-> List<Any> functions : List<Any>
```

```title="Example"
results := Fiber.runConcurrently([
    -> : {
        Fiver.wait(1000);
        return "Hello";
    },
    -> : {
        Fiver.wait(3000);
        return "World";
    },
    -> : {
        Fiver.wait(2000);
        return "!";
    },
]);

# this takes only around 3-4 seconds
# prints ["Hello", "World", "!"]
print(results);
```
