# Overview

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with necessary basic features. Beize script files have an `.beize` extension. The program can be compiled using Beize Compiler and can be run on Beize VM.

!!! info

    - Optional things are mentioned within brackets (`[]`). Escaped brackets (`\[\]`) says that they are part of the syntax itself.

## Comments

Words in a line after `#` are comments. Multi-line comments are not supported.

```
# This is a comment.
```

## Keywords

```
true
false
null
if
else
while
fun
return
break
continue
obj
try
catch
throw
import
as
list
map
when
match
```

## Identifiers

Identifiers are made up of alphabets (`A-Z`, `a-z`), dollar sign (`$`) and underscore (`_`). Numbers (`0-9`) can also be used but are not allowed at the start of an identifier. Keywords cannot be used as identifiers.

Beize does not have a standard naming convention but camel-case is preferred.

```
helloWorld
HelloWorld
_helloWorld
$HELLO_WORLD
hello_world
$hello123
```

## Expressions

Expression is a piece of code that is evaluated to a value. Literals, operations using operators, identifiers come under expressions.

```
helloWorld
1 + 2
"Hello World!"
```

!!! info

    Trailing commas are allowed in function parameters, function call, object key-value pairs and list values. For example, `[1, 2, 3,]` is perfectly valid and same as `[1, 2, 3]`.

## Statements

Statements is a line of code that commands a task. Each program is made up of sequence of statements. Statements must end with a semi-colon (`;`).
