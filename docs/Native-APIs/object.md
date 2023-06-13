# Object

## `Object.from`

Takes in an object and returns the clone of it.

```
Object.from({});
# {}

Object.from({ hello: "world" });
# { hello: "world" }
```

## `Object.fromEntries`

Takes in an list of entries and returns an object.

```
Object.fromEntries([]);
# {}

Object.fromEntries([["hello", "world"]]);
# { hello: "world" }
```

## `Object.apply`

Takes in two objects and returns object A after applying properties of object B to object A.

```
a := {};
b := {
    hello: "world",
};

Object.apply(a, b);

print a;
# { hello: "world" }
```

## `Object.entries`

Takes in an object and returns a list of key-value pairs in a list.

```
Object.entries({ hello: "world", foo: "bar" });
# [["hello", "world"], ["foo", "bar"]]
```

## `Object.keys`

Takes in an object and returns a list of keys.

```
Object.keys({ hello: "world", foo: "bar" });
# ["hello", "foo"]
```

## `Object.values`

Takes in an object and returns a list of values.

```
Object.values({ hello: "world", foo: "bar" });
# ["world", "bar"]
```

## `Object.clone`

Takes in an object and returns a clone of it.

```
Object.clone({ hello: "world" });
# { hello: "world" }
```

## `Object.deleteProperty`

Takes in an object, a key and removes the key from the object.

```
value := { hello: "world", foo: "bar" };
Object.deleteProperty(value, "hello");
print value;
# { foo: "bar" }
```
