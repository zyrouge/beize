# List

## `List.from`

Takes in a value and returns a list. If the value is a list, the list is cloned. If the value is a map, the entries are returned. An exception is thrown if it is neither of these.

```
List.from([0, 1, 2]);
# [0, 1, 2]

List.from({ hello: "world" });
# [["hello", "world"]]
```

## `List.generate`

Takes in a length, a predicate that returns a value and returns the generated list.

```
List.from(3, -> i : i + 1);
# [1, 2, 3]
```

## `List.filled`

Takes in a length, a value and returns the list.

```
List.from(3, 10);
# [10, 10, 10]
```
