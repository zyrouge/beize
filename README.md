<p align="center">
    <img src="./media/banner.png" width="100%">
</p>

# Beize

A highly dynamic embeddable scripting language.

[![GitHub Release](https://img.shields.io/github/v/release/zyrouge/beize)](https://github.com/zyrouge/beize/releases/latest)
[![GitHub](https://img.shields.io/github/license/zyrouge/beize)](./LICENSE)
[![Release](https://github.com/zyrouge/beize/actions/workflows/release.yml/badge.svg)](https://github.com/zyrouge/beize/actions/workflows/release.yml)
[![Test](https://github.com/zyrouge/beize/actions/workflows/test.yml/badge.svg)](https://github.com/zyrouge/beize/actions/workflows/test.yml)
[![Documentation](https://github.com/zyrouge/beize/actions/workflows/docs.yml/badge.svg)](https://github.com/zyrouge/beize/actions/workflows/docs.yml)

# Language Specification

The language syntax is a mix of Go and JavaScript. It is also highly dynamic with necessary basic features. Beize script files have an `.beize` extension. The [`beize_compiler`](./packages/beize_compiler) and [`beize_vm`](./packages/beize_vm) provides the compiler and the runtime for the language.

But, is it fast? The performance is reasonable for a mere scripting language. It can do `100000` iterations and function calls in around 225 milliseconds. I would say, it's pretty freaking good.

# Documentation

Visit [zyrouge.github.io/beize](https://zyrouge.github.io/beize).

# Example

```
text := "Hello World!";
print(text);
```

# License

[GPL-3.0](./LICENSE)
