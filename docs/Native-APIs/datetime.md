# DateTime

## Objects

### `DateTimeInst`

Contains information about the time.

| Property                 | Signature | Description                                                 |
| ------------------------ | --------- | ----------------------------------------------------------- |
| `day`                    | `Number`  | Date of the month. `[1..31]`                                |
| `weekday`                | `Number`  | Day of the week. `[1..7]` (`1` - Monday, ..., `7` - Sunday) |
| `month`                  | `Number`  | Month of the year. `[1..12]`                                |
| `year`                   | `Number`  | Year.                                                       |
| `hour`                   | `Number`  | Hour of the day. `[0..23]`                                  |
| `minute`                 | `Number`  | Minute of the hour. `[0..59]`                               |
| `second`                 | `Number`  | Second of the minute. `[0..59]`                             |
| `millisecond`            | `Number`  | Milliseconds of the second. `[0..999]`                      |
| `millisecondsSinceEpoch` | `Number`  | Number of milliseconds since the Unix Epoch.                |
| `timeZoneName`           | `String`  | Name of the time zone.                                      |
| `timeZoneOffset`         | `Number`  | Difference between local time and UTC in milliseconds.      |
| `iso`                    | `String`  | ISO-8601 full-precision extended format representation.     |

## `DateTime.fromMillisecondsSinceEpoch`

Takes in an number (milliseconds since epoch) and returns a `DateTimeInst`.

```
ms := 1673540148833;
DateTime.fromMillisecondsSinceEpoch(ms);
```

## `DateTime.parse`

Takes in a ISO string, date string, time string or any parsable date-time value and returns a `DateTimeInst`.

```
DateTime.parse("20/10/2023");
```

## `DateTime.now`

Returns a `DateTimeInst` of current time.

```
DateTime.now();
```
