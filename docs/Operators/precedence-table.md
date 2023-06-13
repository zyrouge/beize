# Precedence Table

| Name                   | Operator    | Precedence |
| ---------------------- | ----------- | ---------- |
| Default                | -           | 0          |
| Declaration            | `… := …`    | 1          |
| Assignment             | `… = …`     | 1          |
| Ternary                | `… ? … : …` | 1          |
| Logical OR             | `… \|\| …`  | 2          |
| Nullable OR            | `… ?? …`    | 2          |
| Logical AND            | `… && …`    | 3          |
| Bitwise OR             | `… \| …`    | 4          |
| Bitwise XOR            | `… ^ …`     | 5          |
| Bitwise AND            | `… & …`     | 6          |
| Equality               | `… == …`    | 7          |
| Inequality             | `… != …`    | 7          |
| Lesser Than            | `… < …`     | 8          |
| Lesser Than Or Equal   | `… <= …`    | 8          |
| Greater Than           | `… > …`     | 8          |
| Greater Than Or Equal  | `… >= …`    | 8          |
| Addition               | `… + …`     | 9          |
| Subtraction            | `… - …`     | 9          |
| Multiplication         | `… * …`     | 10         |
| Division               | `… / …`     | 10         |
| Floor Division         | `… // …`    | 10         |
| Remainder              | `… % …`     | 10         |
| Exponent               | `… ** …`    | 11         |
| Logical NOT            | `! …`       | 12         |
| Bitwise NOT            | `~ …`       | 12         |
| Unary Plus             | `+ …`       | 12         |
| Unary Negation         | `- …`       | 12         |
| Call                   | `… ()`      | 13         |
| Member Access          | `… . …`     | 13         |
| Computed Member Access | `… [ … ]`   | 13         |
| Nullable Access        | `… ?. …`    | 13         |
| Grouping               | `( … )`     | 14         |
