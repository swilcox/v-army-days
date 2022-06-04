module main

import time


fn test_completed_days() {
	test_settings := [
		[false, true],
		[true, true],
		[false, false],
		[true, false]
	]
	for settings in test_settings {
		data := DayEntries{
			{"useArmyButtDays": settings[0], "showCompleted": settings[1]},
			[DayEntry{"test entry", "1989-06-03T00:00:00-05:00"}]
		}
		strings := get_display_days(data)
		total := if settings[1] {1} else {0}
		assert strings.len == total
		if strings.len == 1 {
			assert strings[0] == "Completed: test entry."
		}		
	}
}

fn test_future_1_day() {
	// exactly 1 day
	for army in [true, false] {
		future_date := time.utc().add_days(1)
		mut data := DayEntries{
			{"useArmyButtDays": army, "showCompleted": true},
			[DayEntry{"test entry", future_date.strftime("%Y-%m-%dT%H:%M:%S-00:00")}]
		}
		strings := get_display_days(data)
		assert strings.len == 1
		assert strings[0] == "1 day until test entry."
	}
}

fn test_future_2_days() {
	// exactly 2 days
	for army in [true, false] {
		future_date := time.utc().add_days(2)
		data := DayEntries{
			{"useArmyButtDays": army, "showCompleted": true},
			[DayEntry{"test entry", future_date.strftime("%Y-%m-%dT%H:%M:%S-00:00")}]
		}
		strings := get_display_days(data)
		assert strings.len == 1
		assert strings[0] == "2 days until test entry."
	}
}

fn test_fractional_days() {
	// 2 day + 2 hours
	test_settings := [false, true]
	for army in test_settings {
		future_date := time.utc().add_days(2).add_seconds(60 * 60 * 2)
		mut data := DayEntries{
			{"useArmyButtDays": army, "showCompleted": true},
			[DayEntry{"test entry", future_date.strftime("%Y-%m-%dT%H:%M:%S-00:00")}]
		}
		strings := get_display_days(data)
		assert strings.len == 1
		if army {
			assert strings[0] == "2 and a butt days until test entry."
		} else {
			assert strings[0] == "3 days until test entry."
		}
	}
}

fn test_today() {
	future_date := time.utc()
	// all combinations of settings should treat "today" the same
	test_settings := [
		[true, false],
		[true, true],
		[false, false],
		[false, true]
	]
	for settings in test_settings {
		data := DayEntries{
			{"useArmyButtDays": settings[0], "showCompleted": settings[1]},
			[DayEntry{"test entry", future_date.strftime("%Y-%m-%dT%H:%M:%S-00:00")}]
		}
		strings := get_display_days(data)
		assert strings.len == 1
		assert strings[0] == "Today is test entry."
	}
}

fn test_filled_string() {
	assert filled_string("test", 10) == "test      "
	assert filled_string("this is too long", 10) == "this is to"
	assert filled_string("this is to", 10) == "this is to"
}

/* missing:
- get_config() bad / good results
- a few other odd / bad code paths
- testing output function
- additional fractional days 2 hours etc...
- swap out main() for other function so we can test (can't run main())
- test command line params?
*/
