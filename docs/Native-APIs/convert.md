# Convert

## `Convert.newBytesList`

Takes in an optional byte list and returns a `BytesList`.

```title="Signature"
-> [List<Number> bytes] : List<Number>
```

```title="Example"
bytesList1 := Convert.newBytesList();
bytesList2 := Convert.newBytesList([0, 1, 2]);
```

## `Convert.encodeAscii`

Takes in a string and returns a `BytesList`.

```title="Signature"
-> String : BytesList
```

```title="Example"
# internally, [72, 101, 108, 108, 111]
Convert.encodeAscii("Hello");
```

## `Convert.decodeAscii`

Takes in a `BytesList` and returns a string.

```title="Signature"
-> BytesList : String
```

```title="Example"
bytesList := Convert.newBytesList([72, 101, 108, 108, 111]);
decoded := Convert.decodeAscii(bytesList);

# prints "Hello"
print decoded;
```

## `Convert.encodeBase64`

Takes in a `BytesList` and returns a base64 string.

```title="Signature"
-> BytesList : String
```

```title="Example"
bytesList := Convert.newBytesList([72, 101, 108, 108, 111]);
base64 := Convert.encodeBase64(bytesList);

# prints "SGVsbG8="
print base64;
```

## `Convert.decodeBase64`

Takes in a base64 string and returns a `BytesList`.

```title="Signature"
-> String : BytesList
```

```title="Example"
# internally, [72, 101, 108, 108, 111]
Convert.decodeBase64("SGVsbG8=");
```

## `Convert.encodeLatin1`

Takes in a string and returns a `BytesList`.

```title="Signature"
-> String : BytesList
```

```title="Example"
# internally, [72, 101, 108, 108, 111]
Convert.encodeLatin1("Hello");
```

## `Convert.decodeLatin1`

Takes in a `BytesList` and returns a string.

```title="Signature"
-> BytesList : String
```

```title="Example"
bytesList := Convert.newBytesList([72, 101, 108, 108, 111]);
decoded := Convert.decodeLatin1(bytesList);

# prints "Hello"
print decoded;
```

## `Convert.encodeUtf8`

Takes in a string and returns a `BytesList`.

```title="Signature"
-> String : BytesList
```

```title="Example"
# internally, [72, 101, 108, 108, 111]
Convert.encodeUtf8("Hello");
```

## `Convert.decodeUtf8`

Takes in a `BytesList` and returns a string.

```title="Signature"
-> BytesList : String
```

```title="Example"
bytesList := Convert.newBytesList([72, 101, 108, 108, 111]);
decoded := Convert.decodeUtf8(bytes);

# prints "Hello"
print decoded;
```

## `Convert.encodeJson`

Takes in a value and returns json string.

```title="Signature"
-> Any : String
```

```title="Example"
json := {
    hello: "world",
};
encoded := Convert.encodeJson(json);

# prints `{"hello":"world"}`
print encoded;
```

## `Convert.decodeJson`

Takes in a json string and returns a value.

```title="Signature"
-> String : Any
```

```title="Example"
json := '{"hello":"world"}';
decoded := Convert.decodeJson(json);

# prints { hello: "world" }
print decoded;
```

## `BytesList` (Private)

An internally represented bytes list.

### `bytes`

Returns the bytes as a list.

```title="Signature"
-> : List<Number>
```

```title="Example"
bytesList := Convert.newBytesList([0, 1, 2]);

# prints [0, 1, 2]
print bytesList.bytes();
```
