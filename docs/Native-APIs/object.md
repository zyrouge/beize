# Object

## `Object.from`

Takes in an object and returns the clone of it.

```title="Signature"
-> Object value : Object
```

```title="Example"
obj := { hello: "world" };
cloned := Object.from(obj);

# prints { hello: "world" }
prints cloned;
```

## `Object.fromEntries`

Takes in an list of entries and returns an object.

```title="Signature"
-> List<List<Any, Any>> entries : Object
```

```title="Example"
entries := [["hello", "world"]];
obj := Object.fromEntries(entries);

# prints { hello: "world" }
prints obj;
```

## `Object.apply`

Takes in two objects and returns object A after applying properties of object B to object A.

```title="Signature"
-> Object a, Object b : Object
```

```title="Example"
a := {};
b := {
    hello: "world",
};
Object.apply(a, b);

# prints { hello: "world" }
print(a);
```

## `Object.entries`

Takes in an object and returns a list of key-value pairs in a list.

```title="Signature"
-> Object obj : List<List<Any, Any>>
```

```title="Example"
obj := {
    hello: "world",
    foo: "bar",
};
entries := Object.entries(obj);

# prints [["hello", "world"], ["foo", "bar"]]
print(entries);
```

## `Object.keys`

Takes in an object and returns a list of keys.

```title="Signature"
-> Object obj : List<Any>
```

```title="Example"
obj := {
    hello: "world",
    foo: "bar",
};
keys := Object.keys(obj);

# prints ["hello", "foo"]
print(keys);
```

## `Object.values`

Takes in an object and returns a list of values.

```title="Signature"
-> Object obj : List<Any>
```

```title="Example"
obj := {
    hello: "world",
    foo: "bar",
};
values := Object.values(obj);

# prints ["hello", "foo"]
print(values);
```

## `Object.clone`

Takes in an object and returns a clone of it.

```title="Signature"
-> Object obj : Object
```

```title="Example"
obj := { hello: "world" };
cloned := Object.clone();

# prints { hello: "world" }
print(cloned);
```

## `Object.deleteProperty`

Takes in an object, a key and removes the key from the object.

```title="Signature"
-> Object obj, Any key : Object
```

```title="Example"
obj := {
    hello: "world",
    foo: "bar",
};
Object.deleteProperty(obj, "hello");

# prints { foo: "bar" }
print(obj);
```
