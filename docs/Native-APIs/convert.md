# Convert

## Objects

### `BytesList`

An internally represented bytes list.

| Property | Signature           | Description                  |
| -------- | ------------------- | ---------------------------- |
| `bytes`  | `-> : List<Number>` | Returns the bytes as a list. |

## `Convert.newBytesList`

Takes in an optional byte list and returns a `BytesList`.

```
bytes := Convert.newBytesList();
# internally, []

bytes = Convert.newBytesList([0, 1, 2]);
# internally, [0, 1, 2]

bytes.bytes();
# returns the internal list, [0, 1, 2]
```

## `Convert.encodeAscii`

Takes in a string and returns a `BytesList`.

```
Convert.encodeAscii("Hello");
# internally, [72, 101, 108, 108, 111]
```

## `Convert.decodeAscii`

Takes in a `BytesList` and returns a string.

```
bytes := Convert.newBytesList([72, 101, 108, 108, 111]);
Convert.decodeAscii(bytes);
# Hello
```

## `Convert.encodeBase64`

Takes in a `BytesList` and returns a base64 string.

```
bytes := Convert.newBytesList([72, 101, 108, 108, 111]);
Convert.encodeBase64(bytes);
# SGVsbG8=
```

## `Convert.decodeBase64`

Takes in a base64 string and returns a `BytesList`.

```
Convert.decodeBase64("SGVsbG8=");
# internally, [72, 101, 108, 108, 111]
```

## `Convert.encodeLatin1`

Takes in a string and returns a `BytesList`.

```
Convert.encodeLatin1("Hello");
# internally, [72, 101, 108, 108, 111]
```

## `Convert.decodeLatin1`

Takes in a `BytesList` and returns a string.

```
bytes := Convert.newBytesList([72, 101, 108, 108, 111]);
Convert.decodeLatin1(bytes);
# Hello
```

## `Convert.encodeUtf8`

Takes in a string and returns a `BytesList`.

```
Convert.encodeUtf8("Hello");
# internally, [72, 101, 108, 108, 111]
```

## `Convert.decodeUtf8`

Takes in a `BytesList` and returns a string.

```
bytes := Convert.newBytesList([72, 101, 108, 108, 111]);
Convert.decodeUtf8(bytes);
# Hello
```

## `Convert.encodeJson`

Takes in a value and returns json string.

```
json := {
    hello: "world",
};
Convert.encodeJson(json);
# {"hello":"world"}
```

## `Convert.decodeJson`

Takes in a json string and returns a value.

```
json := '{"hello":"world"}';
Convert.decodeJson(json);
# { hello: "world" }
```
