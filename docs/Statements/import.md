# Import Statements

Import statements are used to import other modules into current module. The top-most lexical scope of the module is mirrored.

```title="Syntax"
import "filename" as variable;
```

```title="Example"
import "utils.fbs" as utils;

print utils.helloWorld;
utils.displayHelloWorld();
```
