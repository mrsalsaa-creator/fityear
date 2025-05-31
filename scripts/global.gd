extends Node

var first_open_midnight: int
var current_day: int = 1

var workout_data: Array = []

func _ready():
	load_or_initialize_first_open_midnight()
	calculate_current_day()
	load_workout_data()

func load_workout_data():
	var file = FileAccess.open("res://data/workout_plan.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		var parser = JSON.new()
		var err = parser.parse(text)
		if err != OK:
			push_error("Failed to parse workout JSON: %s" % str(err))
			workout_data = []
		else:
			workout_data = parser.get_data()
	else:
		push_error("Could not open workout_plan.json")

func load_or_initialize_first_open_midnight():
	var config = ConfigFile.new()
	var path = "user://userdata.cfg"

	if config.load(path) != OK:
		# First time running the app — compute today's midnight timestamp
		var now_unix = Time.get_unix_time_from_system()
		var now_dict = Time.get_datetime_dict_from_system()
		var seconds_since_midnight = now_dict.hour * 3600 + now_dict.minute * 60 + now_dict.second
		first_open_midnight = now_unix - seconds_since_midnight
		config.set_value("user", "first_open_midnight", first_open_midnight)
		config.save(path)
	else:
		first_open_midnight = int(config.get_value("user", "first_open_midnight", 0))
		if first_open_midnight == 0:
			# If somehow missing or zero, recompute
			var now_unix2 = Time.get_unix_time_from_system()
			var now_dict2 = Time.get_datetime_dict_from_system()
			var sec_mid2 = now_dict2.hour * 3600 + now_dict2.minute * 60 + now_dict2.second
			first_open_midnight = now_unix2 - sec_mid2
			config.set_value("user", "first_open_midnight", first_open_midnight)
			config.save(path)

func calculate_current_day():
	# Compute today's midnight timestamp
	var now_unix = Time.get_unix_time_from_system()
	var now_dict = Time.get_datetime_dict_from_system()
	var seconds_since_midnight = now_dict.hour * 3600 + now_dict.minute * 60 + now_dict.second
	var today_midnight = now_unix - seconds_since_midnight

	# Compute full days passed since first_open_midnight
	var seconds_diff = today_midnight - first_open_midnight
	var days_passed = int(seconds_diff / 86400)  # 86400 seconds in a day
	current_day = clamp(days_passed + 1, 1, 365)
	print("Current Workout Day: %d" % current_day)

func get_day_title() -> String:
	var entry = get_workout_entry()
	return entry.get("title", "Workout")

func get_day_details() -> String:
	var entry = get_workout_entry()
	return entry.get("description", "No description available.")

func get_workout_entry() -> Dictionary:
	for entry in workout_data:
		if entry.get("day", 0) == current_day:
			return entry
	return {}  # fallback if not found
