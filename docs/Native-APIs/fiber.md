# Fiber

## `Fiber.wait`

Takes in duration in milliseconds and returns a future that resolved after the duration.

```
Future.wait(1000);
# waits 1 second
```

## `Fiber.runConcurrently`

Takes in a list of functions that returns the list of values returned.

```
Fiber.runConcurrently([-> : result1, -> : result2, ..., -> : resultN]);
```
