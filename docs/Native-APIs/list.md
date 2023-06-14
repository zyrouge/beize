# List

## `List.from`

Takes in a value and returns a list. If the value is a list, the list is cloned. If the value is a map, the entries are returned. An exception is thrown if it is neither of these.

```title="Signature"
-> (Object | List<Any>) value : List<Any>
```

```title="Example"
list1 := List.from([0, 1, 2]);
list2 := List.from({ hello: "world" });

# prints [0, 1, 2]
print list1;

# prints [["hello", "world"]]
print list2;
```

## `List.generate`

Takes in a length, a predicate that returns a value and returns the generated list.

```title="Signature"
-> Number length : String
```

```title="Example"
list := List.from(3, -> i : i + 1);

# prints [1, 2, 3]
print list;
```

## `List.filled`

Takes in a length, a value and returns the list.

```title="Signature"
-> Any value : String
```

```title="Example"
list := List.from(3, 10);

# prints [10, 10, 10]
print list;
```
