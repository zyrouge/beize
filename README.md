<p align="center">
    <img src="https://github.com/yukino-org/media/blob/main/images/subbanners/gh-fubuki-banner.png?raw=true" width="100%">
</p>

# Fubuki

🖊️ A hand-crafted scripting language exclusively made for Tenka modules.

# Language Specification

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with only basic features. Fubuki script files takes an extension of `.fbs`. The `fubuki_compiler` and `fubuki_vm` provides the compiler and the runtime for the language.

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
}

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
```

## Control Structures

```
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
# importing comments
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
