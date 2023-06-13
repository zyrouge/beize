# Nullable Access

Nullable Access operator (`?.`) can be used to access properties of an object or `null`. This returns `null`, if the accessor is on a `null` value.

```title="Syntax"
value?.property
```

```title="Example"
someObjectValueOrNull?.propertyA
someObjectValueOrNull?.propertyA.propertyB

# can also be used with computed member access
someObjectValueOrNull?.['propertyA']

# can also be used with calls
someFunctionValueOrNull?.()
```
