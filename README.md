<p align="center">
    <img src="https://github.com/yukino-org/media/blob/main/images/subbanners/gh-fubuki-banner.png?raw=true" width="100%">
</p>

# Fubuki

🖋️ A hand-crafted scripting language exclusively made for Tenka modules.

# Language Specification

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with only basic features. Fubuki script files takes an extension of `.fbs`. The [`fubuki_compiler`](./packages/fubuki_compiler) and [`fubuki_vm`](./packages/fubuki_vm) provides the compiler and the runtime for the language.

But is it fast? The performance is reasonable for a mere scripting language. It can do `100000` iterations and function calls in less than 1.5 seconds. I would say, it's pretty freaking good.

# Documentation

Refer [wiki/fubuki](https://yukino-org.github.io/wiki/fubuki/).

# Example

```
text := "Hello World!";
print text;
```

# License

[GPL-3.0](./LICENSE)
