<p align="center">
    <img src="./media/banner.png" width="100%">
</p>

# Baize

🖋️ A scripting language made for unknown reasons.

# Language Specification

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with only basic features. Baize script files have an `.baize` extension. The [`baize_compiler`](./packages/baize_compiler) and [`baize_vm`](./packages/baize_vm) provides the compiler and the runtime for the language.

But is it fast? The performance is reasonable for a mere scripting language. It can do `100000` iterations and function calls in less than 1.5 seconds. I would say, it's pretty freaking good for a mere scripting language.

# Documentation

Refer [wiki/baize](https:///).

# Example

```
text := "Hello World!";
print text;
```

# License

[GPL-3.0](./LICENSE)
