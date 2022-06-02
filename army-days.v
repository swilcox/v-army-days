module army_days

import os
import flag
import json
import time
import math

type ConfigItem = string | bool | int | map[string]ConfigItem

struct DayEntry {
	title string
	date string
}

struct DayEntries {
	config map[string]ConfigItem
	entries []DayEntry
}

fn get_config(file_name string) DayEntries {
	bytes := os.read_file(file_name) or {
		println("error opening file!: ${err.msg()}")
		exit(1)
	}
	data := json.decode(DayEntries, bytes) or {
		println("error decoding json file: ${err.msg()}")
		exit(2)
	}
	return data
}

fn get_display_days(data DayEntries) []string {
	mut result := []string{}
	use_army_days := data.config["useArmyButtDays"] or {false} as bool
	show_completed := data.config["showCompleted"] or {false} as bool

	for entry in data.entries {
		ts := time.parse_rfc3339(entry.date) or {continue}
		delta_days := (ts - time.utc()).hours() / 24.0
		mut text := "day"
		mut int_days := int(delta_days)
		if use_army_days && math.round(delta_days) == int_days {
			text = "and a butt " + text
		} else {
			int_days += 1
		}
		if int_days > 1 {
			text += "s"
		}
		if delta_days < 0.0 && delta_days > -1.0 {
			result << "Today is ${entry.title}."
		} else if delta_days < -1.0 {
			if show_completed {
				result << "Completed: ${entry.title}."
			}
		} else {
			result << "${int_days} ${text} until ${entry.title}."
		}
	}
	return result
}

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('army-days')
	fp.version('v0.0.1')
	fp.description('V-Powered Army Days countdown')
	fp.skip_executable()
	file_name := fp.string("filename", `f`, os.join_path_single(os.home_dir(), ".days.json"), "filename for days config")
	show_help := fp.bool("help", `h`, false, "show this help message")

	// show usage
	if show_help {
		println(fp.usage())
		exit(0)
	}

	data := get_config(file_name)
	output := get_display_days(data)
	println(output.join('\n'))
}
