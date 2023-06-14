# List

Represents a list of values.

```title="Syntax"
\[[expr1, expr2, ..., exprN]\]
```

```title="Example"
[]
[1, 2, 3]
```

## Properties

### `push`

Adds `value` to the list.

```title="Signature"
-> Any value : Null
```

```title="Example"
list := ["foo"];
list.push("bar");

# prints ["foo", "bar"]
print list;
```

### `pushAll`

Adds all values of `values` to the list.

```title="Signature"
-> List<Any> values : Null
```

```title="Example"
list := ["foo"];
list.pushAll(["bar", "baz"]);

# prints ["foo", "bar", "baz"]
print list;
```

### `pop`

Removes the last element.

```title="Signature"
-> : Null
```

```title="Example"
list := ["foo", "bar"];
list.pop();

# prints ["foo"]
print list;
```

### `clear`

Removes all the elements.

```title="Signature"
-> : Null
```

```title="Example"
list := ["foo", "bar"];
list.pop();

# prints ["foo"]
print list;
```

### `length`

Returns length of the list.

```title="Signature"
-> : Number
```

```title="Example"
list := ["foo", "bar"];

# prints 2
print list.length();
```

### `isEmpty`

Is the list empty?

```title="Signature"
-> : Boolean
```

```title="Example"
list := ["foo", "bar"];

# prints false
print list.isEmpty();
```

### `isNotEmpty`

Is the list not empty?

```title="Signature"
-> : Boolean
```

```title="Example"
list := ["foo", "bar"];

# prints true
print list.isNotEmpty();
```

### `clone`

Returns clone of the list.

```title="Signature"
-> : List<Any>
```

```title="Example"
list := ["foo", "bar"];
cloned = list.clone();

# prints ["foo", "bar"]
print cloned;
```

### `reversed`

Returns reversed clone of the list.

```title="Signature"
-> : List<Any>
```

```title="Example"
list := ["foo", "bar"];
reversed := list.reversed();

# prints ["bar", "foo"]
print reversed;
```

### `contains`

Check if `element` is present in the list.

```title="Signature"
-> Any element : Boolean
```

```title="Example"
list := ["foo", "bar"];

# prints true
print list.contains("bar");
```

### `indexOf`

Returns the index of `element` in the list.

```title="Signature"
-> Any element : Boolean
```

```title="Example"
list := ["foo", "bar", "foo"];

# prints 0
print list.indexOf("foo");
```

### `lastIndexOf`

Returns the last index of `element` in the list.

```title="Signature"
-> Any element : Boolean
```

```title="Example"
list := ["foo", "bar", "foo"];

# prints 2
print list.lastIndexOf("foo");
```

### `remove`

Removes all `element` from the list.

```title="Signature"
-> Any element : Boolean
```

```title="Example"
list := ["foo", "bar"];
list.remove("bar");

# prints ["foo"]
print list;
```

### `sublist`

Returns a sub-list consisting elements between `start` and `end` (exclusive).

```title="Signature"
-> Number start, Number end : List<Any>
```

```title="Example"
list := ["foo", "bar", "baz"];
sublist := list.sublist(0, 2);

# prints ["foo", "bar"]
print sublist;
```

### `find`

Returns the matched element using the `predicate`.

```title="Signature"
-> (-> Any element : Boolean) predicate : Any
```

```title="Example"
list := [
    { value: "foo" },
    { value: "bar" },
];

# prints { value: "foo" }
print list.find(-> x : x.value == "foo");
```

### `findIndex`

Returns the index of matched element using the `predicate`.

```title="Signature"
-> (-> Any element : Boolean) predicate : Number
```

```title="Example"
list := [
    { value: "foo" },
    { value: "bar" },
];

# prints 1
print list.findIndex(-> x : x.value == "bar");
```

### `findLastIndex`

Returns the last index of matched element using the `predicate`.

```title="Signature"
-> (-> Any element : Boolean) predicate : Number
```

```title="Example"
list := [
    { value: "foo" },
    { value: "bar" },
    { value: "foo" },
];

# prints 2
print list.findLastIndex(-> x : x.value == "foo");
```

### `map`

Returns the list of mapped values using `predicate`.

```title="Signature"
-> (-> Any element : Any) predicate : List<Any>
```

```title="Example"
list := [
    { value: "foo" },
    { value: "bar" },
];
mapped := list.map(-> x : x.value);

# prints ["foo", "bar"]
print mapped;
```

### `filter`

Returns the list of filtered values using `predicate`.

```title="Signature"
-> (-> Any element : Boolean) predicate : List<Any>
```

```title="Example"
list := ["foo", "bar", "baz"];
filtered := list.filter(-> x : x.value == "foo");

# prints ["bar", "baz"]
print filtered;
```

### `sort`

Returns the sorted list of using `sortBy`.

```title="Signature"
-> (-> Any a, Any b : Number) sortBy : List<Any>
```

```title="Example"
list := ["c", "a", "b"];
sorted := list.sort(-> a, b : a.compareTo(b));

# prints ["a", "b", "c"]
print sorted;
```

### `flat`

Returns the flattened list of level `level`.

```title="Signature"
-> Number level : List<Any>
```

```title="Example"
list := [["foo", "bar"], ["baz"]];
flattened := list.flat(1);

# prints ["foo", "bar", "baz"]
print flattened;
```

### `flatDeep`

Returns the deep flattened list.

```title="Signature"
-> : List<Any>
```

```title="Example"
list := [["foo", ["bar"]], ["baz"]];
flattened := list.flatDeep();

# prints ["foo", "bar", "baz"]
print flattened;
```

### `unique`

Returns the list of unique elements.

```title="Signature"
-> : List<Any>
```

```title="Example"
list := ["foo", "bar", "foo"];
unique := list.unique();

# prints ["foo", "bar"]
print unique;
```

### `forEach`

Iterates the list using `predicate`.

```title="Signature"
-> (-> Any element : Null) predicate : Null
```

```title="Example"
list1 := ["foo", "bar"];
list2 := [];

list1.forEach(-> x : list2.add(x));

# prints ["foo", "bar"]
print list2;
```

### `join`

Returns the elements converted to string, joined by `delimiter`.

```title="Signature"
-> String delimiter : String
```

```title="Example"
list := ["foo", "bar"];

# prints "foo, bar"
print list.join(", ");
```
