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

### `pushAll`

Adds all values of `values` to the list.

```title="Signature"
-> List<Any> values : Null
```

### `pop`

Removes the last element.

```title="Signature"
-> : Null
```

### `clear`

Removes all the elements.

```title="Signature"
-> : Null
```

### `length`

Returns length of the list.

```title="Signature"
-> : Number
```

### `isEmpty`

Is the list empty?

```title="Signature"
-> : Boolean
```

### `isNotEmpty`

Is the list not empty?

```title="Signature"
-> : Boolean
```

### `clone`

Returns clone of the list.

```title="Signature"
-> : List<Any>
```

### `reversed`

Returns reversed clone of the list.

```title="Signature"
-> : List<Any>
```

### `contains`

Check if `element` is present in the list.

```title="Signature"
-> Any element : Boolean
```

### `indexOf`

Returns the index of `element` in the list.

```title="Signature"
-> Any element : Boolean
```

### `lastIndexOf`

Returns the last index of `element` in the list.

```title="Signature"
-> Any element : Boolean
```

### `remove`

Removes all `element` from the list.

```title="Signature"
-> Any element : Boolean
```

### `sublist`

Returns a sub-list consisting elements between `start` and `end`.

```title="Signature"
-> Number start, Number end : List<Any>
```

### `find`

Returns the matched element using the `predicate`.

```title="Signature"
-> (predicate: (element: Any) : Boolean) => Any
```

### `findIndex`

Returns the index of matched element using the `predicate`.

```title="Signature"
-> (predicate: (element: Any) : Boolean) => Number
```

### `findLastIndex`

Returns the last index of matched element using the `predicate`.

```title="Signature"
-> (predicate: (element: Any) : Boolean) => Number
```

### `map`

Returns the list of mapped values using `predicate`.

```title="Signature"
-> (predicate: (element: Any) : Any) => List<Any>
```

### `filter`

Returns the list of filtered values using `predicate`.

```title="Signature"
-> (predicate: (element: Any) : Boolean) => List<Any>
```

### `sort`

Returns the sorted list of using `sortBy`.

```title="Signature"
-> (sortBy: (a: Any, b: Any) : Number) => List<Any>
```

### `flat`

Returns the flatted list of level `level`.

```title="Signature"
-> Number level : List<Any>
```

### `flatDeep`

Returns the flatted list of level `this.length`.

```title="Signature"
-> : List<Any>
```

### `unique`

Returns the list of unique elements.

```title="Signature"
-> : List<Any>
```

### `forEach`

Iterates the list using `predicate`.

```title="Signature"
-> (predicate: (element: Any) : Null) => Null
```

### `join`

Returns the elements converted to string, joined by `delimiter`.

```title="Signature"
-> String delimiter : String
```
