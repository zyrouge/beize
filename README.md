<p align="center">
    <img src="https://github.com/yukino-org/media/blob/main/images/subbanners/gh-fubuki-banner.png?raw=true" width="100%">
</p>

# Fubuki

🖋️ A hand-crafted scripting language exclusively made for Tenka modules.

# Language Specification

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with only basic features. Fubuki script files takes an extension of `.fbs`. The [`fubuki_compiler`](./packages/fubuki_compiler) and [`fubuki_vm`](./packages/fubuki_vm) provides the compiler and the runtime for the language.

But is it fast? The performance is reasonable for a mere scripting language. It can do `100000` iterations and function calls in less than 1.5 seconds. I would say, it's pretty freaking good.

## Things to remember

- Each expression must end with a semi-colon. Even functions are considers as expressions and must end with a semi-colon.
- Trailing commas are allowed in function arguments, function calls, object, list and map declarations.
- Comments are start with `#`. Any characters after `#` is ignored.
- Strings are multiline by default.
- Never leave instances of `Future`s unawaited. Unawaited futures are ignored by the virtual machine.

## Variables and Data Types

```
# declaration
x := value;

# assignment
x = value;

# number, internally represented as double
a := 125;
b := 120.52;

# string
c := "Hello World!";

# boolean
d := true;
e := false;

# object (javascript-like)
f := obj {
    key: value,
    [expr]: value,
};

# map (dart-like)
g := map {
    'key': value,
    expr: value,
};

# list
h := list [value1, value2, value3];

# function or closures
i := fun (p1) {
    return value;
};
j := fun {
    return value;
};
```

## Function

```
# function declaration
function_name := fun {
    return value;
};

# function call
function_name();
```

## Objects

```
# object declaration
object := obj {
    prop1: value,
    prop2: value,
};

# object get and sets
object.prop1;
object["prop1"];
object.prop2 = value;

# null safe operators
nullableObject?.prop3;
nullableObject?.["prop3"];
nullableObject?.prop4 = value;
```

## Operators

Name | Operator | Precedence
--- | --- | ---
Default | - | 0
Declaration | `… := …` | 1
Assignment | `… = …` | 1
Ternary | `… ? … : …` | 1
Logical OR | `… \|\| …` | 2
Nullable OR | `… ?? …` | 2
Logical AND | `… && …` | 3
Bitwise OR | `… \| …` | 4
Bitwise XOR | `… ^ …` | 5
Bitwise AND | `… & …` | 6
Equality | `… == …` | 7
Inequality | `… != …` | 7
Lesser Than | `… < …` | 8
Lesser Than Or Equal | `… <= …` | 8
Greater Than | `… > …` | 8
Greater Than Or Equal | `… >= …` | 8
Addition | `… + …` | 9
Subtraction | `… - …` | 9
Multiplication | `… * …` | 10
Division | `… / …` | 10
Floor Division | `… // …` | 10
Remainder | `… % …` | 10
Exponent | `… ** …` | 11
Logical NOT | `! …` | 12
Bitwise NOT | `~ …` | 12
Unary Plus | `+ …` | 12
Unary Negation | `- …` | 12
Call | `… ()` | 13
Member Access | `… . …` | 13
Computed Member Access | `… [ … ]` | 13
Nullable Access | `… ?. …` | 13
Grouping | `( … )` | 14

## Control Structures

```
# ternary
condition ? trueValue : falseValue;

# if
if (condition) {
    # do something
} else {
    # else do something
}

# while
while (condition) {
    # do something
    # also supports these
    break;
    continue;
}
```

## Modules

```
# importing modules
import "./modulename.fbs" as importName;

importName.somethingThatIsDeclaredInThatFile;
```

## Try-catch

```
try {
    # some unsafe code
} catch (error) {
    # handle it
}
```

## Asynchronous using Future

```
# creates a future
futureValue := Future.new();

# resolve a future
futureValue.complete("Hello World!");

# fail a future
futureValue.fail("Goodbye");

# get value from a future
value := futureValue.await();
```

## Examples

### Hello World!

```
print "Hello World!";
```

### Area of shapes

```
square := obj {
    area: fun (side) {
        return side * side;
    },
};

rectangle := obj {
    area: fun (length, breadth) {
        return length * breadth;
    },
};

print "Area of square: " + square.area(5);
print "Area of rectangle: " + rectangle.area(2, 3);
```

### Print until 100 and as a list

```
i := 0;
numbers := list [];
while (i <= 100) {
    print i;
    numbers.add(i);
}
print numbers;
```

# License

[GPL-3.0](./LICENSE)
