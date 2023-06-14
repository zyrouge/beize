# DateTime

## `DateTime.fromMillisecondsSinceEpoch`

Takes in an number (milliseconds since epoch) and returns a `DateTimeInst`.

```title="Signature"
-> Number millisecondsSinceEpoch : DateTimeInst
```

```title="Example"
ms := 1330329420000;
time := DateTime.fromMillisecondsSinceEpoch(ms);

# prints "2012-02-27T13:27:00.000"
print time.iso;
```

## `DateTime.parse`

Takes in a ISO string, date string, time string or any parsable date-time value and returns a `DateTimeInst`.

Examples of accepted strings:

-   `2012-02-27`
-   `2012-02-27 13:27:00`
-   `2012-02-27 13:27:00.123456789z`
-   `2012-02-27 13:27:00,123456789z`
-   `20120227 13:27:00`
-   `20120227T132700`
-   `20120227`
-   `+20120227`
-   `2012-02-27T14Z`
-   `2012-02-27T14+00:00`
-   `-123450101 00:00:00 Z": in the year -12345`
-   `2002-02-27T14:00:00-0500": Same as "2002-02-27T19:00:00Z`

```title="Signature"
-> String millisecondsSinceEpoch : DateTimeInst
```

```title="Example"
time := DateTime.parse("2012-02-27 13:27:00");

# prints "2012-02-27T13:27:00.000"
print time.iso;
```

## `DateTime.now`

Returns a `DateTimeInst` of current time.

```title="Signature"
-> : DateTimeInst
```

```title="Example"
time := DateTime.now();

# prints "2012-02-27T13:27:00.000"
print time.iso;
```

## `DateTimeInst` (Private)

Contains information about the time.

### `day`

Date of the month. `[1..31]`

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 27
print now.day;
```

### `weekday`

Day of the week. `[1..7]` (`1` - Monday, ..., `7` - Sunday)

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 1
print now.weekday;
```

### `month`

Month of the year. `[1..12]`

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 2
print now.month;
```

### `year`

Year.

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 2012
print now.year;
```

### `hour`

Hour of the day. `[0..23]`

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 13
print now.hour;
```

### `minute`

Minute of the hour. `[0..59]`

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 27
print now.minute;
```

### `second`

Second of the minute. `[0..59]`

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:01");

# prints 1
print now.second;
```

### `millisecond`

Milliseconds of the second. `[0..999]`

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00.12345");

# prints 12345
print now.millisecond;
```

### `millisecondsSinceEpoch`

Number of milliseconds since the Unix Epoch.

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 1330329420000
print now.millisecondsSinceEpoch;
```

### `timeZoneName`

Name of the time zone.

```title="Signature"
String
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints "Pacific Standard Time"
print now.timeZoneName;
```

### `timeZoneOffset`

Difference between local time and UTC in milliseconds.

```title="Signature"
Number
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints 60000
print now.timeZoneOffset;
```

### `iso`

ISO-8601 full-precision extended format representation.

```title="Signature"
String
```

```title="Example"
now := DateTime.parse("2012-02-27 13:27:00");

# prints "2012-02-27T13:27:00.000"
print now.iso;
```
