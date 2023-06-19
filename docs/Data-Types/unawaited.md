# Unawaited

Represents a asynchronous function call that has not been `await`ed.

```title="Example"
unawaitedValue := someAsyncFunction();

# prints "<unawaited>"
print(typeof(unawaitedValue));

resolvedValue := unawaitedValue.await;
```
