# army-days

## Overview

This is the VLang-based version.

`army-days` CLI program to display the number of remaining days until a particular event.


## Testing and Compiling

**Note:** This assumes you have [V](https://vlang.io/) installed.

### To run the tests

```bash
v -stats test .
```

This will give you some nice detail about the tests run and their status.

### To compile

```bash
v army-days.v
```

This will create an `army-days` executable (probably in less than second).

## Usage

If you just execute `army-days` by itself, it will look for a json configuration file in your user `HOME` directory called `.days.json`. If you supply the `-f` or `--filename` option, you scan specify a JSON file elsewhere.

### Configuration file structure

```json
{
    "config": {
        "useArmyButtDays": true,
        "showCompleted": false
    },
    "entries": [
        {
            "title": "title of an event you care about",
            "date": "2029-01-01T00:00:00-00:00"
        }
    ]
}
```
There are two configuration options:

* `useArmyButtDays` - essentially whether to indicate nearest half (butt) day or only to round up to the nearest whole day.
* `showCompleted` - whether to display completed events or not.

The `entries` is an array of objects that have both a `title` and a `date`. The `date` is an RFC3999 format with `YYYY-MM-DDThh:mm:ss-hh:mm` where the offset hh:mm is difference from UTC. This is important since the difference in time between the current date/time and the event is computed by accounting for timezone.

So since the Army-Navy game takes place in the Eastern timezone (and not during daylight saving time), the time and offset to the start of gameday (not the time of kickoff) is 00:00:00-05:00 (i.e. midnight EST).

