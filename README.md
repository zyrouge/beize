<p align="center">
    <img src="./media/banner.png" width="100%">
</p>

# Beize

🖋️ A scripting language made for unknown reasons.

# Language Specification

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with only basic features. Beize script files have an `.beize` extension. The [`beize_compiler`](./packages/beize_compiler) and [`beize_vm`](./packages/beize_vm) provides the compiler and the runtime for the language.

But is it fast? The performance is reasonable for a mere scripting language. It can do `100000` iterations and function calls in around 1.5 seconds. I would say, it's pretty freaking good.

# Documentation

Refer [wiki/beize](https:///).

# Example

```
text := "Hello World!";
print text;
```

# License

[GPL-3.0](./LICENSE)
