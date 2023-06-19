# Area of shapes

```
square := {
    area: -> side : side * side,
};

rectangle := {
    area: -> length, breadth : length * breadth,
};

print("Area of square: " + square.area(5));
print("Area of rectangle: " + rectangle.area(2, 3));
```
