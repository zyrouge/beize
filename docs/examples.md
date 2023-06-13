# Examples

## Hello World!

```
print "Hello World!";
```

## Area of shapes

```
square := {
    area: -> side : side * side,
};

rectangle := {
    area: -> length, breadth : length * breadth,
};

print "Area of square: " + square.area(5);
print "Area of rectangle: " + rectangle.area(2, 3);
```

## Print until 100 and as a list

```
numbers := [];
for (i := 0; i <= 100; i++) {
    print i;
    numbers.add(i);
}
print numbers;
```
